# Requirements Definition Document (RDD) — *Logseq Menu TODO*

## 1. Assumptions & Constraints

* **Read-only**: No writes or state changes to Logseq data at any time.
* **Data source**: Local Logseq graph (**Markdown only**).
* **Display statuses**: Support **multiple selectable statuses**; **defaults: `TODO`, `DOING`**.
* **Sorting**: Toggle between **Newest first / Oldest first**.

  * “Newest first” uses **`created-at`** as the primary key; if absent, fall back to **file mtime**.
* **Auto-reload**: Default **60 seconds** (user-configurable).
* **Not included in the initial release**: Clicking an item to open the target in Logseq.
* **License**: **MIT**.

## 2. Supported Environment

* **OS**: **macOS 15 (Sequoia) or later**.
* **CPU**: **Apple Silicon (arm64 only)**; Intel is not supported.

## 3. Functional Requirements (FR)

**F-001 Menu bar residency & UI**

* The app resides in the macOS menu bar; clicking the icon opens/closes a popover UI.

**F-002 Task retrieval (read-only)**

* Parse **`.md`** files under `pages/` and `journals/` in the selected Logseq graph.
* Extract **incomplete tasks** whose status matches the user’s selection (defaults: `TODO`, `DOING`).

**F-003 Sorting**

* Allow switching between **Newest first / Oldest first** (criteria defined in §1).

**F-004 Reload**

* Provide **auto-reload** (default 60s) and **manual reload**.

**F-005 Settings**

* Let users configure: graph folder, display statuses (multiple), sort order, and reload interval.
* Persist settings across app restarts.

**F-006 Display fields**

* For each task, show: **title (first line)**, **status**, **created-at** (or mtime fallback), and **page name or journal date**.

**F-007 Errors & empty states**

* Show appropriate messages for: no graph selected, insufficient permissions, parse failures, or zero matching tasks.

**F-008 Accessibility & operability**

* Provide keyboard operability and VoiceOver labels.

## 4. Non-Functional Requirements (NFR)

* **Performance**: Snappy menu open/close (target < **150 ms**). Initial list generation for large graphs should complete within a few seconds.
* **Resource usage**: Resident memory < **150 MB**; negligible CPU at idle.
* **Robustness**: Do not crash on malformed Markdown or unknown properties; skip gracefully.
* **Security & privacy**: App Sandbox enabled; access limited to the selected folder; **no network egress**.
* **Internationalization**: UI in **Japanese** initially (English can follow).
* **Logging**: Local debug logs only; **no external telemetry**.

## 5. Data & Parsing Requirements

* **Target files**: `.md` files under `pages/` and `journals/`.
* **Task detection**: Lines with a leading status token, e.g., `- TODO ...`, `- DOING ...`.
* **Sort keys**: `created-at` > file mtime.
* **Identifiers**: Use block `id` when available; otherwise derive a pseudo-ID (file path + line number, etc.).

## 6. Distribution Requirements

* **Primary distribution**: **Homebrew Cask**.
* **Artifacts**: Ship the app bundle as `.zip` or `.dmg` on **GitHub Releases**, referenced by the Cask (`url` and `sha256`).
* **CI**: **GitHub Actions** to build and output `sha256` (Developer ID signing & notarization **recommended**).

