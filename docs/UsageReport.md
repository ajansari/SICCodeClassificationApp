# Usage Report — SIC Code Classification

Measured per step (ALL ALONG → Usage & Cost Tracking; Ops § Usage & Cost). Tokens from Claude Code's transcripts; Copilot steps show premium requests in *Notes*. Cost at published API rates.
| Step | Model(s) | Input | Output | Cache write | Cache read | Cost (USD) | Elapsed | Turns | Decisions | Sub-agent calls | Senior AL dev est. (h) | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Unattributed (STEP-1 through STEP-7) | claude-sonnet-5 | 354 | 112,045 | 709,037 | 29,956,549 | 9.95 | n/a — no timestamps | 12 | 2 | 0 | 38.5 (DesignDoc.md B11 scope only — see note) | 177 requests |
| **Total** | | 354 | 112,045 | 709,037 | 29,956,549 | 9.95 | | | | | | |

*Prices: https://platform.claude.com/docs/en/about-claude/pricing, read 2026-09-27. Human estimate: `docs/HumanEffortEstimate.md`. Copilot steps: premium requests in Notes, `n/a` in the token and cost columns.*

**What changed since the last refresh (2026-09-26, $5.59 total):** the prior refresh's `.ocpf/usage.json`
(with its guessed per-step start timestamps) is gone — `.ocpf/` is gitignored per developer, and it
wasn't present at the start of this refresh. It was recreated fresh with no step windows, so this
refresh can only report one combined figure across the entire project to date, not a per-step
breakdown; every prior request is still included (this total is a superset of the earlier $5.59 —
same transcript file, more turns since). **Nothing is estimated or backfilled** — a guessed step
boundary would misattribute requests, so this reports true totals rather than a fabricated split.

The **Senior AL dev est. (h)** column carries `docs/HumanEffortEstimate.md`'s total (38.5h), but that
estimate was written before the Step 5 Feedback 1 scope addition (the customer-count drill-down,
Table 77079, Pages 77080–77082) — it only covers the original 8-object design. It understates the
actual delivered scope and should be revisited if this comparison matters going forward.

## Before calling a refresh done
- [x] Every step with a start timestamp has a row; a step that couldn't be measured says why —
      no step has a timestamp this refresh, so everything is one `Unattributed` row, explained above.
- [x] The Total row and the pricing footnote are current.
