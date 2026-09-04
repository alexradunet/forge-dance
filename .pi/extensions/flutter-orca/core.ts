export const ACTIONS = ["start", "reload", "restart", "relaunch", "stop", "status"];
export const TERMINAL_TITLE = "Forge Dance — Flutter Android";

export function parseAction(value) {
  const action = String(value ?? "").trim().toLowerCase();
  return ACTIONS.includes(action) ? action : undefined;
}

export function shellQuote(value) {
  return `'${String(value).replaceAll("'", `'\"'\"'`)}'`;
}

export function extractVmServiceUri(output) {
  const lines = String(output).split("\n");
  for (let index = 0; index < lines.length; index += 1) {
    if (!/\b(?:dart\s+)?vm service\b/i.test(lines[index])) continue;
    const readinessText = lines.slice(index, index + 3).join(" ");
    const match = readinessText.match(/https?:\/\/[^\s]+/i);
    if (match) return match[0].replace(/[),.;]+$/, "");
  }
  return undefined;
}

export function classifyFlutterResponse(action, output) {
  const text = String(output);
  const failed = /(?:try again after fixing|failed to hot reload|hot reload was rejected|compilation failed|errors? detected)/i.test(text);
  if (failed) return { state: "failed" };

  if (action === "reload" && /(?:reloaded \d+(?: of \d+)? libraries|hot reload complete)/i.test(text)) {
    return { state: "succeeded" };
  }
  if (action === "restart" && /restarted application in/i.test(text)) {
    return { state: "succeeded" };
  }
  return { state: "pending" };
}

export function classifyRuntimePhase(state, runnerAlive, terminal) {
  if (!runnerAlive || !terminal) return "stopped";
  return state?.phase === "ready" ? "ready" : "starting";
}

export function findManagedTerminal(terminals, state, worktreePath) {
  const candidates = (terminals ?? []).filter(
    (terminal) => !worktreePath || terminal.worktreePath === worktreePath,
  );
  return (
    candidates.find((terminal) => state?.terminalHandle && terminal.handle === state.terminalHandle) ??
    candidates.find((terminal) => state?.ptyId && terminal.ptyId === state.ptyId) ??
    candidates.find((terminal) => terminal.title === TERMINAL_TITLE)
  );
}
