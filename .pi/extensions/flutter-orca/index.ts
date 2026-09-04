import { mkdir, readFile, rename, writeFile } from "node:fs/promises";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { StringEnum } from "@earendil-works/pi-ai";
import { Type } from "typebox";
import {
  ACTIONS,
  TERMINAL_TITLE,
  classifyFlutterResponse,
  classifyRuntimePhase,
  extractVmServiceUri,
  findManagedTerminal,
  parseAction,
  shellQuote,
} from "./core.ts";

type Action = (typeof ACTIONS)[number];
type JsonObject = Record<string, any>;
type ManagedState = {
  version: number;
  phase?: "starting" | "ready" | "stopped";
  runnerPid?: number;
  terminalHandle?: string;
  ptyId?: string;
  worktreeId?: string;
  vmServiceUri?: string;
  startCursor?: string;
  updatedAt?: number;
  exitCode?: number;
};

type RuntimeStatus = {
  phase: "unavailable" | "stopped" | "starting" | "ready";
  state: ManagedState;
  terminal?: JsonObject;
  message: string;
};

const STATUS_KEY = "flutter-orca";
const START_TIMEOUT_MS = 120_000;
const RELOAD_TIMEOUT_MS = 45_000;
const POLL_MS = 750;

function sleep(milliseconds: number, signal?: AbortSignal): Promise<void> {
  return new Promise((resolve, reject) => {
    if (signal?.aborted) {
      reject(signal.reason ?? new Error("Cancelled"));
      return;
    }
    const timer = setTimeout(resolve, milliseconds);
    signal?.addEventListener(
      "abort",
      () => {
        clearTimeout(timer);
        reject(signal.reason ?? new Error("Cancelled"));
      },
      { once: true },
    );
  });
}

function orcaExecutable(): string {
  if (process.env.ORCA_CLI_COMMAND) return process.env.ORCA_CLI_COMMAND;
  if (process.env.ORCA_DEV_REPO_ROOT) return "orca-dev";
  return process.platform === "linux" ? "orca-ide" : "orca";
}

function statePaths(cwd: string) {
  return {
    state: join(cwd, "build", "live", "flutter-orca-state.json"),
    runner: join(cwd, ".pi", "extensions", "flutter-orca", "runner.sh"),
  };
}

async function readState(cwd: string): Promise<ManagedState> {
  try {
    return JSON.parse(await readFile(statePaths(cwd).state, "utf8")) as ManagedState;
  } catch {
    return { version: 1, phase: "stopped" };
  }
}

async function updateState(cwd: string, patch: Partial<ManagedState>): Promise<ManagedState> {
  const path = statePaths(cwd).state;
  const next: ManagedState = { ...(await readState(cwd)), ...patch, version: 1, updatedAt: Date.now() };
  for (const [key, value] of Object.entries(next)) {
    if (value === undefined) delete (next as JsonObject)[key];
  }
  await mkdir(join(cwd, "build", "live"), { recursive: true });
  await writeFile(`${path}.pi.tmp`, `${JSON.stringify(next, null, 2)}\n`, "utf8");
  await rename(`${path}.pi.tmp`, path);
  return next;
}

async function isRunnerAlive(cwd: string, state: ManagedState): Promise<boolean> {
  if (!state.runnerPid || state.phase === "stopped") return false;
  try {
    process.kill(state.runnerPid, 0);
  } catch {
    return false;
  }

  if (process.platform !== "linux") return true;
  try {
    const commandLine = await readFile(`/proc/${state.runnerPid}/cmdline`, "utf8");
    return commandLine.includes(statePaths(cwd).runner);
  } catch {
    return false;
  }
}

function textFromTerminalRead(payload: JsonObject): string {
  const tail = payload?.result?.terminal?.tail;
  if (Array.isArray(tail)) return tail.join("\n");
  return typeof tail === "string" ? tail : "";
}

function cursorFromTerminalRead(payload: JsonObject): string | undefined {
  const terminal = payload?.result?.terminal;
  return terminal?.latestCursor ?? terminal?.nextCursor;
}

function terminalFromPayload(payload: JsonObject): JsonObject | undefined {
  return payload?.result?.terminal ?? payload?.result?.startupTerminal;
}

export default function flutterOrcaExtension(pi: ExtensionAPI) {
  let operationQueue: Promise<void> = Promise.resolve();

  function serialized<T>(operation: () => Promise<T>): Promise<T> {
    const result = operationQueue.then(operation, operation);
    operationQueue = result.then(
      () => undefined,
      () => undefined,
    );
    return result;
  }

  async function runOrca(args: string[], signal?: AbortSignal, timeout = 15_000): Promise<JsonObject> {
    const result = await pi.exec(orcaExecutable(), args, { signal, timeout });
    let payload: JsonObject | undefined;
    try {
      payload = JSON.parse(result.stdout || result.stderr) as JsonObject;
    } catch {
      // The exact CLI error below is more useful than a JSON parser error.
    }
    if (result.code !== 0 || payload?.ok === false) {
      const detail = payload?.error?.message ?? payload?.error?.code ?? result.stderr ?? result.stdout;
      throw new Error(`Orca command failed: ${detail || `exit ${result.code}`}`);
    }
    if (!payload) throw new Error(`Orca returned invalid JSON for: ${args.join(" ")}`);
    return payload;
  }

  async function ensureOrca(signal?: AbortSignal): Promise<void> {
    try {
      await runOrca(["status", "--json"], signal);
    } catch {
      await runOrca(["open", "--json"], signal, 30_000);
      const deadline = Date.now() + 15_000;
      while (Date.now() < deadline) {
        try {
          await runOrca(["status", "--json"], signal);
          return;
        } catch {
          await sleep(POLL_MS, signal);
        }
      }
      throw new Error("Orca did not become ready within 15 seconds");
    }
  }

  async function listTerminals(cwd: string, signal?: AbortSignal): Promise<JsonObject[]> {
    const payload = await runOrca(
      ["terminal", "list", "--worktree", `path:${cwd}`, "--json"],
      signal,
    );
    return payload?.result?.terminals ?? [];
  }

  async function inspect(cwd: string, signal?: AbortSignal): Promise<RuntimeStatus> {
    const state = await readState(cwd);
    try {
      await runOrca(["status", "--json"], signal);
    } catch {
      return { phase: "unavailable", state, message: "Orca is unavailable" };
    }

    const terminals = await listTerminals(cwd, signal);
    const terminal = findManagedTerminal(terminals, state, cwd);
    const alive = await isRunnerAlive(cwd, state);

    if (terminal && (terminal.handle !== state.terminalHandle || terminal.ptyId !== state.ptyId)) {
      await updateState(cwd, {
        terminalHandle: terminal.handle,
        ptyId: terminal.ptyId,
        worktreeId: terminal.worktreeId,
      });
    }

    const phase = classifyRuntimePhase(state, alive, terminal);
    if (phase !== "stopped") {
      return {
        phase,
        state: { ...state, terminalHandle: terminal!.handle, ptyId: terminal!.ptyId },
        terminal,
        message: phase === "ready" ? "Flutter is running" : "Flutter is starting",
      };
    }

    const stopped = await updateState(cwd, {
      phase: "stopped",
      runnerPid: undefined,
      vmServiceUri: undefined,
      startCursor: undefined,
      terminalHandle: terminal?.handle ?? state.terminalHandle,
      ptyId: terminal?.ptyId ?? state.ptyId,
      worktreeId: terminal?.worktreeId ?? state.worktreeId,
    });
    return { phase: "stopped", state: stopped, terminal, message: "Flutter is stopped" };
  }

  function setFooter(ctx: any, phase: RuntimeStatus["phase"]): void {
    const labels = {
      unavailable: "Flutter: Orca unavailable",
      stopped: "Flutter: stopped",
      starting: "Flutter: starting",
      ready: "Flutter: running",
    };
    ctx.ui.setStatus(STATUS_KEY, labels[phase]);
  }

  async function readTerminal(handle: string, cursor?: string, signal?: AbortSignal): Promise<JsonObject> {
    const args = ["terminal", "read", "--terminal", handle];
    if (cursor !== undefined) args.push("--cursor", cursor);
    args.push("--limit", "1000", "--json");
    return runOrca(args, signal);
  }

  async function waitForReadiness(
    cwd: string,
    handle: string,
    initialCursor: string | undefined,
    signal?: AbortSignal,
  ): Promise<string> {
    let cursor = initialCursor;
    let output = "";
    const deadline = Date.now() + START_TIMEOUT_MS;
    while (Date.now() < deadline) {
      const read = await readTerminal(handle, cursor, signal);
      const chunk = textFromTerminalRead(read);
      if (chunk) output = `${output}\n${chunk}`.slice(-20_000);
      cursor = cursorFromTerminalRead(read) ?? cursor;

      const uri = extractVmServiceUri(output);
      if (uri) return uri;
      const state = await readState(cwd);
      if (!(await isRunnerAlive(cwd, state)) && state.phase === "stopped") {
        throw new Error(`Flutter exited before becoming ready.\n${output.slice(-2000)}`);
      }
      await sleep(POLL_MS, signal);
    }
    throw new Error(`Flutter did not expose a VM-service URI within two minutes.\n${output.slice(-2000)}`);
  }

  async function focusTerminal(handle: string, signal?: AbortSignal): Promise<void> {
    await runOrca(["terminal", "switch", "--terminal", handle, "--json"], signal);
  }

  async function start(cwd: string, signal?: AbortSignal, focus = true): Promise<string> {
    await ensureOrca(signal);
    await runOrca(["worktree", "show", "--worktree", `path:${cwd}`, "--json"], signal);

    let current = await inspect(cwd, signal);
    if (current.phase === "ready" || current.phase === "starting") {
      if (focus && current.terminal) await focusTerminal(current.terminal.handle, signal);
      if (current.phase === "ready") return "Flutter is already running in Orca.";
      const uri = await waitForReadiness(
        cwd,
        current.terminal!.handle,
        current.state.startCursor,
        signal,
      );
      await updateState(cwd, { phase: "ready", vmServiceUri: uri, startCursor: undefined });
      return `Flutter finished starting in Orca (${uri}).`;
    }

    const paths = statePaths(cwd);
    const command = `bash ${shellQuote(paths.runner)} ${shellQuote(paths.state)} ${shellQuote(cwd)}`;
    let terminal = current.terminal;
    let initialCursor: string | undefined;

    await updateState(cwd, {
      phase: "starting",
      runnerPid: undefined,
      vmServiceUri: undefined,
      startCursor: undefined,
      exitCode: undefined,
    });

    if (terminal?.writable) {
      initialCursor = cursorFromTerminalRead(await readTerminal(terminal.handle, undefined, signal));
      await runOrca(
        ["terminal", "send", "--terminal", terminal.handle, "--text", command, "--enter", "--json"],
        signal,
      );
      await runOrca(
        ["terminal", "rename", "--terminal", terminal.handle, "--title", TERMINAL_TITLE, "--json"],
        signal,
      );
      if (focus) await focusTerminal(terminal.handle, signal);
    } else {
      const args = [
        "terminal",
        "create",
        "--worktree",
        `path:${cwd}`,
        "--title",
        TERMINAL_TITLE,
        "--command",
        command,
      ];
      if (focus) args.push("--focus");
      args.push("--json");
      const created = await runOrca(args, signal, 30_000);
      terminal = terminalFromPayload(created);
      if (!terminal?.handle) {
        const terminals = await listTerminals(cwd, signal);
        terminal = findManagedTerminal(terminals, undefined, cwd);
      }
      if (!terminal?.handle) throw new Error("Orca created the Flutter terminal but returned no terminal handle");
    }

    await updateState(cwd, {
      phase: "starting",
      terminalHandle: terminal.handle,
      ptyId: terminal.ptyId,
      worktreeId: terminal.worktreeId,
      startCursor: initialCursor,
    });

    const uri = await waitForReadiness(cwd, terminal.handle, initialCursor, signal);
    await updateState(cwd, { phase: "ready", vmServiceUri: uri, startCursor: undefined });
    return `Flutter is ready in Orca (${uri}).`;
  }

  async function waitForFlutterResponse(
    cwd: string,
    action: "reload" | "restart",
    handle: string,
    initialCursor: string | undefined,
    signal?: AbortSignal,
  ): Promise<string> {
    let cursor = initialCursor;
    let output = "";
    const deadline = Date.now() + RELOAD_TIMEOUT_MS;
    while (Date.now() < deadline) {
      const read = await readTerminal(handle, cursor, signal);
      const chunk = textFromTerminalRead(read);
      if (chunk) output = `${output}\n${chunk}`.slice(-20_000);
      cursor = cursorFromTerminalRead(read) ?? cursor;
      const classification = classifyFlutterResponse(action, output);
      if (classification.state === "succeeded") return output;
      if (classification.state === "failed") {
        throw new Error(`Flutter ${action} failed.\n${output.slice(-2000)}`);
      }
      const state = await readState(cwd);
      if (!(await isRunnerAlive(cwd, state))) throw new Error(`Flutter exited during ${action}`);
      await sleep(POLL_MS, signal);
    }
    throw new Error(`Timed out waiting for Flutter ${action}.\n${output.slice(-2000)}`);
  }

  async function reloadOrRestart(
    cwd: string,
    action: "reload" | "restart",
    signal?: AbortSignal,
  ): Promise<string> {
    const current = await inspect(cwd, signal);
    if (current.phase !== "ready" || !current.terminal) {
      throw new Error("Flutter is not ready. Run /flutter start first.");
    }
    const before = await readTerminal(current.terminal.handle, undefined, signal);
    const cursor = cursorFromTerminalRead(before);
    const key = action === "reload" ? "r" : "R";
    await runOrca(
      ["terminal", "send", "--terminal", current.terminal.handle, "--text", key, "--json"],
      signal,
    );
    await waitForFlutterResponse(cwd, action, current.terminal.handle, cursor, signal);
    return action === "reload" ? "Flutter hot reload completed." : "Flutter hot restart completed.";
  }

  async function stop(cwd: string, signal?: AbortSignal): Promise<string> {
    const current = await inspect(cwd, signal);
    if (current.phase === "unavailable") throw new Error("Orca is unavailable; the managed terminal cannot be stopped safely");
    if (current.phase === "stopped") return "Flutter is already stopped.";
    if (!current.terminal) throw new Error("The managed Flutter process has no writable Orca terminal");

    await runOrca(
      ["terminal", "send", "--terminal", current.terminal.handle, "--text", "q", "--json"],
      signal,
    );
    let deadline = Date.now() + 8_000;
    while (Date.now() < deadline) {
      if (!(await isRunnerAlive(cwd, await readState(cwd)))) {
        await updateState(cwd, {
          phase: "stopped",
          runnerPid: undefined,
          vmServiceUri: undefined,
          startCursor: undefined,
        });
        return "Flutter stopped; its Orca terminal remains open.";
      }
      await sleep(POLL_MS, signal);
    }

    await runOrca(
      ["terminal", "send", "--terminal", current.terminal.handle, "--interrupt", "--json"],
      signal,
    );
    deadline = Date.now() + 5_000;
    while (Date.now() < deadline) {
      if (!(await isRunnerAlive(cwd, await readState(cwd)))) {
        await updateState(cwd, {
          phase: "stopped",
          runnerPid: undefined,
          vmServiceUri: undefined,
          startCursor: undefined,
        });
        return "Flutter required an interrupt to stop; its Orca terminal remains open.";
      }
      await sleep(POLL_MS, signal);
    }
    throw new Error("Flutter did not stop after a graceful quit and terminal interrupt");
  }

  async function perform(action: Action, cwd: string, signal?: AbortSignal): Promise<string> {
    switch (action) {
      case "start":
        return start(cwd, signal, true);
      case "reload":
      case "restart":
        return reloadOrRestart(cwd, action, signal);
      case "relaunch":
        await stop(cwd, signal);
        return start(cwd, signal, true);
      case "stop":
        return stop(cwd, signal);
      case "status": {
        const status = await inspect(cwd, signal);
        const uri = status.state.vmServiceUri ? ` (${status.state.vmServiceUri})` : "";
        return `${status.message}${uri}.`;
      }
    }
  }

  async function performAndRefresh(action: Action, ctx: any, signal?: AbortSignal): Promise<string> {
    try {
      const message = await serialized(() => perform(action, ctx.cwd, signal));
      const status = await inspect(ctx.cwd, signal);
      setFooter(ctx, status.phase);
      return message;
    } catch (error) {
      const status = await inspect(ctx.cwd).catch(() => undefined);
      setFooter(ctx, status?.phase ?? "unavailable");
      throw error;
    }
  }

  pi.registerCommand("flutter", {
    description: "Control Forge Dance in Orca: start, reload, restart, relaunch, stop, or status",
    getArgumentCompletions: (prefix: string) => {
      const normalized = prefix.trim().toLowerCase();
      if (ACTIONS.includes(normalized)) return null;
      const matches = ACTIONS.filter((action: string) => action.startsWith(normalized));
      return matches.length > 0
        ? matches.map((action: string) => ({ value: action, label: action }))
        : null;
    },
    handler: async (args, ctx) => {
      const action = parseAction(args) as Action | undefined;
      if (!action) {
        ctx.ui.notify(`Usage: /flutter <${ACTIONS.join("|")}>`, "warning");
        return;
      }
      try {
        const message = await performAndRefresh(action, ctx);
        ctx.ui.notify(message, "info");
      } catch (error) {
        ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
      }
    },
  });

  pi.registerTool({
    name: "flutter_orca",
    label: "Flutter Orca",
    description: "Control the Forge Dance Flutter debug app in Orca and wait for each requested operation to finish.",
    promptSnippet: "Start, inspect, hot reload, hot restart, relaunch, or stop Forge Dance in Orca",
    promptGuidelines: [
      "Use flutter_orca after a coherent Dart change under lib/ when Forge Dance is already running; do not reload after incomplete intermediate edits.",
    ],
    parameters: Type.Object({
      action: StringEnum(ACTIONS as readonly string[], {
        description: "Operation to perform on the managed Flutter debug process",
      }),
    }),
    async execute(_toolCallId, params, signal, _onUpdate, ctx) {
      const message = await performAndRefresh(params.action as Action, ctx, signal);
      return {
        content: [{ type: "text", text: message }],
        details: { action: params.action, state: await readState(ctx.cwd) },
      };
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    const status = await inspect(ctx.cwd).catch(() => undefined);
    setFooter(ctx, status?.phase ?? "unavailable");
  });
}
