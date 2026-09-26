# Project Parameters — SIC Code Classification

Completed at Step 1 intake, 2026-09-26. This block is authoritative for the rest of the routine —
every later step reads values from here, never from conversation history or from memory.

| Parameter | Value |
|---|---|
| **Extension Name** | SIC Code Classification |
| **Publisher** | OnlyCopilotFans |
| **Deployment Target** | SaaS PTE |
| **Use Namespace** | Yes |
| **Namespace** | OnlyCopilotFans.SicClassification |
| **Localization** | US |
| **AL Object Prefix** | ocpfsic |
| **APIPublisher** | onlyCopilotFans |
| **APIGroup** | ocpfsicClassification |
| **APIVersion** | v1.0 |
| **Permission Set App Code** | SIC |
| **Permission Set Names** | `OCPFSIC SIC, VIEW` / `OCPFSIC SIC, EDIT` |
| **Object ID range(s)** | 77071–77099 (29 IDs; within the 50,000–99,999 PTE customization range per Standards §5.5) |
| **Permission Sets required?** | Yes (extension owns a new table — Standards §5.3) |
| **AL Runtime** | 17.0 |
| **BC Application Minimum** | 28.0.0.0 (2026 release wave 1 — current BC online major version, verified against Microsoft Learn's runtime table) |
| **Symbol Source** | W1 (global feed) via the AL MCP Server: System 28.0.54016.0, Base Application/System Application 28.5.54151.54677, Business Foundation/Application 28.5.54151.54178. Sufficient to start DESIGN (Ops § Symbols) — a sandbox/US-specific download is deferred until a country-specific table or field needs verification, which nothing planned so far requires. |
| **Onboarding — Assisted Setup Wizard** | Yes — imports the bundled SIC code list into the SIC Code table |
| **Onboarding — Role Center Activity Cues** | No |
| **Onboarding — Departments / "My Business Central" placement** | No |
| **Framework files in `.gitignore`?** | Yes |
| **Working language** | English |
| **Main model & thinking effort** | Sonnet (`claude-sonnet-5`) / Medium — matches what this session is running |
| **Target languages** | None beyond source — United States / en-US only |
| **Source language** | en-US |
| **Source wording** | US wording directly in source, no translation files |
| **Documents in other languages** | N/A — no target language beyond source |
| **Customer-language documents / translatable data** | No / No |

**Quoting reference:** `app.json`/`launch.json` use standard JSON strings; AL string property
values use single quotes (`APIPublisher = 'onlyCopilotFans';`); AL object names use double quotes
(`page 77080 "ocpfsicSicCodes"`); BC field names with spaces use double quotes.

**Entity-naming patterns** (prefix `ocpfsic`, all camelCase — Standards §2.7):
`APIGroup = 'ocpfsicClassification'`, `EntityName = 'ocpfsicSicCode'`,
`EntitySetName = 'ocpfsicSicCodes'`, `ODataKeyFields = SystemId` always. Names ≤ 30 characters
including the prefix.

`NoImplicitWith` is enabled and enforced.
