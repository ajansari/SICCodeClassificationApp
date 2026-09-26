# Usage Report — SICDemo

Measured per step (ALL ALONG → Usage & Cost Tracking; Ops § Usage & Cost). Tokens from Claude Code's transcripts; Copilot steps show premium requests in *Notes*. Cost at published API rates.
| Step | Model(s) | Input | Output | Cache write | Cache read | Cost (USD) | Elapsed | Turns | Decisions | Sub-agent calls | Senior AL dev est. (h) | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| STEP-1+2 | claude-sonnet-5 | 270 | 76,495 | 224,805 | 19,623,188 | 5.59 | n/a — see note | 7 | 17 | 0 | 9 (DEFINE + DESIGN, HumanEffortEstimate.md §4) | 135 requests. Steps 1 and 2 are combined in one row: `.ocpf/usage.json` only has step-start timestamps to the nearest guessed wall-clock minute, not a reliable boundary between Step 1's and Step 2's actual work inside this single continuous session, so splitting them would misattribute requests. Elapsed time is reported `n/a` for the same reason. |
| STEP-3 | | | | | | | | | | | | |
| STEP-4 | | | | | | | | | | | | |
| STEP-5 | | | | | | | | | | | | |
| STEP-6 | | | | | | | | | | | | |
| STEP-7 | | | | | | | | | | | | |
| **Total** | | 270 | 76,495 | 224,805 | 19,623,188 | 5.59 | | | | | | |

*Prices: https://platform.claude.com/docs/en/about-claude/pricing, read 2026-09-26. Human estimate: `docs/HumanEffortEstimate.md`. Copilot steps: premium requests in Notes, `n/a` in the token and cost columns.*

## Before calling a refresh done
- [ ] Every step with a start timestamp has a row; a step that couldn't be measured says why.
- [ ] The Total row and the pricing footnote are current.
