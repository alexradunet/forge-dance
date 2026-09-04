import test from "node:test";
import assert from "node:assert/strict";
import {
  TERMINAL_TITLE,
  classifyFlutterResponse,
  classifyRuntimePhase,
  extractVmServiceUri,
  findManagedTerminal,
  parseAction,
  shellQuote,
} from "./core.ts";

test("parseAction accepts only supported actions", () => {
  assert.equal(parseAction(" reload "), "reload");
  assert.equal(parseAction("HOT-RELOAD"), undefined);
  assert.equal(parseAction(""), undefined);
});

test("shellQuote safely quotes apostrophes", () => {
  assert.equal(shellQuote("a'b"), `'a'"'"'b'`);
});

test("extractVmServiceUri reads Flutter readiness output", () => {
  assert.equal(
    extractVmServiceUri("The Dart VM service is listening on http://127.0.0.1:41231/abc=/"),
    "http://127.0.0.1:41231/abc=/",
  );
  assert.equal(
    extractVmServiceUri(
      "A Dart VM Service on Android is available at:\nhttp://127.0.0.1:41231/abc=/",
    ),
    "http://127.0.0.1:41231/abc=/",
  );
  assert.equal(extractVmServiceUri("Launching lib/main.dart on Android..."), undefined);
});

test("classifyFlutterResponse waits for completion", () => {
  assert.deepEqual(classifyFlutterResponse("reload", "Performing hot reload..."), { state: "pending" });
  assert.deepEqual(classifyFlutterResponse("reload", "Reloaded 3 of 1721 libraries in 842ms."), {
    state: "succeeded",
  });
  assert.deepEqual(classifyFlutterResponse("reload", "Reloaded 0 libraries in 350ms."), {
    state: "succeeded",
  });
  assert.deepEqual(classifyFlutterResponse("restart", "Restarted application in 2,245ms."), {
    state: "succeeded",
  });
  assert.deepEqual(classifyFlutterResponse("reload", "Try again after fixing the above error(s)."), {
    state: "failed",
  });
});

test("classifyRuntimePhase rejects stale process or terminal state", () => {
  assert.equal(classifyRuntimePhase({ phase: "ready" }, true, { handle: "term" }), "ready");
  assert.equal(classifyRuntimePhase({ phase: "starting" }, true, { handle: "term" }), "starting");
  assert.equal(classifyRuntimePhase({ phase: "ready" }, false, { handle: "term" }), "stopped");
  assert.equal(classifyRuntimePhase({ phase: "ready" }, true, undefined), "stopped");
});

test("findManagedTerminal prefers a live handle, then PTY, then title", () => {
  const terminals = [
    { handle: "title", ptyId: "pty-title", title: TERMINAL_TITLE, worktreePath: "/repo" },
    { handle: "pty", ptyId: "wanted-pty", title: "shell", worktreePath: "/repo" },
    { handle: "wanted", ptyId: "other", title: "shell", worktreePath: "/repo" },
  ];
  assert.equal(
    findManagedTerminal(terminals, { terminalHandle: "wanted", ptyId: "wanted-pty" }, "/repo").handle,
    "wanted",
  );
  assert.equal(
    findManagedTerminal(terminals, { terminalHandle: "stale", ptyId: "wanted-pty" }, "/repo").handle,
    "pty",
  );
  assert.equal(findManagedTerminal(terminals, {}, "/repo").handle, "title");
  assert.equal(findManagedTerminal(terminals, {}, "/other"), undefined);
});
