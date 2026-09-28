# SIC Code Classification

A Microsoft Dynamics 365 Business Central extension that adds standard, government-defined
industry classification to Customers using **SIC codes** (Standard Industrial Classification,
U.S. Department of Labor, 1987).

## Why

Business Central has no native support for SIC codes. Today, users who need to classify a
Customer by industry track it outside BC — a spreadsheet, a CRM note — with no validation and no
consistent code list. This extension makes SIC classification a first-class, validated field on
the Customer record.

## What it does

- **SIC Code table** — a reference table holding the full official SIC hierarchy (Division,
  Major Group, Industry Group, and the 4-digit Industry code with description), sourced from
  OSHA's SIC Manual (~1,005 entries) and bundled with the extension.
- **SIC Code field on Customer** — one new field, validated against the SIC Code table via
  `TableRelation`, with the code's description surfaced on the Customer Card.
- **Assisted Setup Wizard** — imports the bundled SIC code list into the SIC Code table on first
  run (re-runnable), registered on Business Central's standard Assisted Setup page.
- **SIC Codes list page** — browse and search the full code list.

SIC codes are static and unchanged since 1987, so the list is bundled with the extension rather
than fetched live — there's no official machine-readable API for it, and a live fetch would be
fragile on many tenants.

## Out of scope

- NAICS codes (the system that replaced SIC for federal statistics in 1997).
- Classification on entities other than Customer (e.g. Vendor, Contact).

## Requirements

- Business Central 28.0 or later.

## Credits

Built by OnlyCopilotFans and [AJ Ansari](mailto:aj@onlycopilotfans.com).

## License

Released under the [MIT License](LICENSE).
