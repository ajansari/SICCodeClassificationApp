# Acknowledgements — SIC Code Classification

SIC Code Classification itself is released under the MIT License — see `LICENSE` at the project
root (© OnlyCopilotFans, created by AJ Ansari).

SIC Code Classification is original work: no third-party source code was copied into `src/`,
`app.json`, or the shipped package. The bundled SIC code list (`resources/SicCodes.txt`) is sourced
from OSHA's public SIC Manual, a U.S. government publication. This document is a courtesy
acknowledgement of the development tooling used to build the extension, not a legal requirement —
see the note at the end for why.

## Development framework

- **OnlyCopilotFans (OCPF) Agentic Development Framework** (Lite edition, runbook v3.1.0.0) —
  © AJ Ansari, MIT License.
  [github.com/ajansari/ocpfBcAgenticDevFramework](https://github.com/ajansari/ocpfBcAgenticDevFramework).
  The DEFINE → DESIGN → BUILD → PROVE routine, AL Development Standards Guide, Operations Guide,
  and document templates this project was built by, through all seven Lite steps.

## Tooling invoked, never bundled

- **AL Language extension for Visual Studio Code** — © Microsoft Corporation. Compiler and
  analyzers (CodeCop, UICop, PerTenantExtensionCop), symbol download, and the bundled AL MCP
  Server, used throughout DESIGN and BUILD for every compile, package, and symbol lookup (including
  verifying the full Customer field list for the Customer API page directly against the downloaded
  Base Application symbols).
- **@mermaid-js/mermaid-cli** — © Mermaid contributors, MIT License. Rendered and verified the
  entity-relationship diagram in `docs/Docs.md` §1.2 before publishing.

## Built with

- **Claude Code** (Anthropic) — the agentic coding tool that ran this project's DEFINE through
  PROVE phases. Main role: Claude Sonnet 5, Medium thinking effort (Lite edition uses a single
  Main role — no separate Reasoning or Light roles).

---

**Why this isn't a license requirement.** None of the above is redistributed inside this
extension. The framework's own design is to never bundle third-party code into a project it
builds — it links to references, or invokes tools the developer already has installed. The 12 AL
objects in `src/` are original work written to satisfy `docs/DesignDoc.md`, not derived from any
of the above. This document exists for transparency, at AJ's request, not because Business
Central, MIT, or any other license here requires it.
