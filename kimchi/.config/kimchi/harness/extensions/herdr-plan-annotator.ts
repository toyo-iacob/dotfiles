// Review Kimchi's submitted plans (submit_plan) in herdr's "annotate" plugin
// pane, and make that pane the permission gate — the Kimchi equivalent of
// Claude Code's open-plan-in-annotator.sh ExitPlanMode hook.
//
// The tool_call handler blocks until the human decides, so plannotator is the
// sole review UI and Kimchi's native plan-review UI can't race it:
// - "approve" record  -> allow; the plan proceeds to execution
// - "feedback" record -> block the tool, with the annotation text as reason
// - pane closed with nothing sent -> no decision; Kimchi's native review UI
//   appears and the human explicitly approves there. Never auto-approve.
//
// Decision channel: plannotator-tui writes a delivery record to
// ~/.plannotator/feedback/<project>/index.jsonl every time Send is pressed
// — one JSON line per send with an explicit "decision" field ("feedback" or
// "approve"), the target file path, and (for feedback) the fully formatted
// annotation text. This extension polls that log instead of pane-injection
// or clipboard. No-op outside herdr panes / non-TUI modes.

import { execFile } from "node:child_process";
import {
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  statSync,
  writeFileSync,
} from "node:fs";
import path from "node:path";

// plannotator-tui has no Approve action (verified across 0.8.0–0.9.2).
// Consider a feedback record an implicit approval when it contains ONLY
// looks-good (👍) annotations — no comments, no deletes.
function isPureLooksGood(feedbackText: string): boolean {
  if (!/Looks good:/.test(feedbackText)) return false;
  if (/Comment on:/.test(feedbackText)) return false;
  if (/delete/i.test(feedbackText)) return false;
  return true;
}

function herdrBin(): string {
  return process.env.HERDR_BIN_PATH || "herdr";
}

function herdr(args: string[]): Promise<string | undefined> {
  return new Promise((resolve) => {
    execFile(herdrBin(), args, { maxBuffer: 16 * 1024 * 1024 }, (err, stdout) =>
      resolve(err ? undefined : stdout)
    );
  });
}

function herdrJson(args: string[]): Promise<any> {
  return herdr(args).then((stdout) => {
    try {
      return stdout ? JSON.parse(stdout) : undefined;
    } catch {
      return undefined;
    }
  });
}

function sleep(ms: number): Promise<void> {
  return new Promise((r) => setTimeout(r, ms));
}

function latestPlan(plansDir: string): string | undefined {
  try {
    const files = readdirSync(plansDir)
      .filter((f) => f.endsWith(".md"))
      .map((f) => path.join(plansDir, f))
      .sort((a, b) => statSync(b).mtimeMs - statSync(a).mtimeMs);
    return files[0];
  } catch {
    return undefined;
  }
}

function readNewRecords(
  feedbackLog: string,
  fromLine: number,
  planFile: string
): any[] {
  try {
    if (!existsSync(feedbackLog)) return [];
    const lines = readFileSync(feedbackLog, "utf8").split("\n");
    const records: any[] = [];
    for (let i = fromLine; i < lines.length; i++) {
      const line = lines[i].trim();
      if (!line) continue;
      try {
        const rec = JSON.parse(line);
        if (rec?.target?.filePath === planFile && rec?.decision) {
          records.push(rec);
        }
      } catch {
        // partial line mid-write; next poll picks it up
      }
    }
    return records;
  } catch {
    return [];
  }
}

export default function (pi: any) {
  if (process.env.HERDR_ENV !== "1") return;
  const paneId = process.env.HERDR_PANE_ID;
  const workspaceId = process.env.HERDR_WORKSPACE_ID;
  if (!paneId || !workspaceId) return;

  let isTui = false;
  pi.on("session_start", async (_event: any, ctx: any) => {
    // Only the TUI has a visible PTY herdr can annotate next to.
    isTui = ctx?.mode === "tui";
    try {
      ctx?.ui?.notify?.("herdr-plan-annotator loaded (gating submit_plan)", "info");
    } catch {
      // notify is cosmetic only
    }
  });

  // Fire before execution (like Claude's PreToolUse hook) and hold while the
  // human reviews in the annotate pane.
  pi.on("tool_call", async (event: any, ctx: any) => {
    if (!isTui) return;
    if (event?.toolName !== "submit_plan") return;

    const cwd: string = ctx?.cwd ?? process.cwd();
    const plansDir = path.join(cwd, ".kimchi", "plans");
    let planFile = latestPlan(plansDir);

    // tool_call fires BEFORE submit_plan flushes the plan to disk, so the
    // newest file on disk can be the PREVIOUS round's plan. The tool input is
    // the source of truth: if it differs from the newest file, stage it and
    // open that instead.
    if (typeof event?.input?.plan === "string" && event.input.plan.trim()) {
      const onDisk =
        planFile && existsSync(planFile)
          ? (() => {
              try {
                return readFileSync(planFile, "utf8");
              } catch {
                return undefined;
              }
            })()
          : undefined;
      if (onDisk !== event.input.plan) {
        try {
          mkdirSync(plansDir, { recursive: true });
          planFile = path.join(plansDir, "annotate-pending.md");
          writeFileSync(planFile, event.input.plan);
        } catch {
          return;
        }
      }
    }
    if (!planFile || !existsSync(planFile)) return;

    const feedbackLog = path.join(
      process.env.HOME ?? "",
      ".plannotator",
      "feedback",
      path.basename(cwd),
      "index.jsonl"
    );
    let linesBefore = 0;
    try {
      if (existsSync(feedbackLog)) {
        linesBefore = readFileSync(feedbackLog, "utf8").split("\n").length - 1;
      }
    } catch {
      // count of zero is fine — only brand-new records match
    }

    // Close stale annotate panes from previous submit_plan calls so repeated
    // plans don't pile up duplicates in this tab.
    const list = await herdrJson(["pane", "list", "--workspace", workspaceId]);
    const panes: any[] = list?.result?.panes ?? [];
    for (const p of panes) {
      if (p?.label === "Annotate" && p?.cwd === cwd && p?.pane_id) {
        await herdr(["plugin", "pane", "close", String(p.pane_id)]);
      }
    }

    // Split-open an 80/20 top annotate pane (same geometry as the Claude hook:
    // open below, swap above, grow to ~80%).
    const openResult = await herdrJson([
      "plugin", "pane", "open",
      "--plugin", "annotate",
      "--entrypoint", "doc",
      "--placement", "split",
      "--direction", "down",
      "--target-pane", paneId,
      "--focus",
      "--cwd", cwd,
      "--env", `PLANNOTATOR_TUI_FILE=${planFile}`,
    ]);
    const annotatePaneId = openResult?.result?.plugin_pane?.pane?.pane_id;
    if (!annotatePaneId) return; // no pane: no gate, native review UI shows

    await herdr(["pane", "swap", "--pane", String(annotatePaneId), "--direction", "up"]);
    await herdr(["pane", "resize", "--pane", String(annotatePaneId), "--direction", "down", "--amount", "0.3"]);

    // Hold the tool call until a decision record appears, or the pane closes.
    while (true) {
      const records = readNewRecords(feedbackLog, linesBefore, planFile);
      if (records.length > 0) {
        const decision = records[records.length - 1].decision;
        if (decision === "approve") return; // allow
        if (decision === "feedback") {
          const reason = records
            .map((r: any) => r?.feedback)
            .filter(Boolean)
            .join("\n");
          // All-👍 annotations and nothing else => implicit approve.
          if (reason && isPureLooksGood(reason)) return;
          return {
            block: true,
            reason: reason || "Plan rejected in plannotator (no annotation text)",
          };
        }
      }

      const alive = await herdr(["pane", "get", String(annotatePaneId)]);
      if (alive === undefined) return; // closed without a decision: native UI
      await sleep(300);
    }
  });
}
