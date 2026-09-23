// Label Kimchi agents as "kimchi (pi)" in the herdr sidebar.
// Loads as a Kimchi (pi-style) extension on every session start.
// No-op outside herdr panes (HERDR_ENV is only set inside herdr).

import { execFile } from "node:child_process";

interface PiApi {
  on(event: string, handler: () => void | Promise<void>): void;
}

export default function (pi: PiApi) {
  pi.on("session_start", () => {
    if (process.env.HERDR_ENV !== "1") return;
    const paneId = process.env.HERDR_PANE_ID;
    const bin = process.env.HERDR_BIN_PATH || "herdr";
    if (!paneId) return;

    const apply = () =>
      new Promise<void>((resolve) => {
        execFile(
          bin,
          [
            "pane",
            "report-metadata",
            paneId,
            "--source",
            "user:kimchi-label",
            "--applies-to-source",
            "herdr:pi",
            "--display-agent",
            "kimchi (pi)",
          ],
          () => resolve()
        );
      });

    // Retry a few times: herdr may classify/replace pane agent state after startup.
    (async () => {
      for (let i = 0; i < 5; i++) {
        await new Promise((r) => setTimeout(r, 1000));
        await apply();
      }
    })();
  });
}
