# Hermes Agent: Global Availability & Workspace Architecture

**Date:** 2026-09-17  
**System Node:** Mac Mini (`300web@Macmini`)  
**Tags:** #architecture #agent #hermes #omniroute #second-brain #graphify

---

## 1. Executive Summary
The **Hermes Agent** (`hermes`) is globally accessible across the entire system from any terminal session and within any project folder. It runs independently of workspace-specific setups while reading shared memories, skills, and configurations from `~/.hermes/`.

---

## 2. CLI Installation & Global Path
* **CLI Wrapper:** `/Users/300web/.local/bin/hermes`
* **Underlying Runtime:** `/Users/300web/.hermes/hermes-agent/venv/bin/python` -> `/Users/300web/.hermes/hermes-agent/hermes`
* **Environment PATH:** `/Users/300web/.local/bin` is exported in the user's `$PATH`.
* **Global Access:** You can invoke `hermes` or `hermes chat` from **any directory** or project folder on this machine.

### Execution Context & State
* **Current Working Directory (CWD):** When launched inside any directory (e.g., `~/Documents/Projects/<any-project>`), Hermes adopts that directory as its workspace context, allowing it to inspect local source code, run tests, and manage files.
* **Persistent Agent State:** Global configuration, skills, agent memories, sessions, and SQLite database reside in `~/.hermes/` (`state.db`, `config.yaml`, `skills/`, `memories/`).

---

## 3. Interaction with VS Code Workspace Tasks
In the `Hermes-Omniroute` project folder, `.vscode/tasks.json` defines auto-startup tasks on folder open (`Hi Freddie`):
1. **OmniRoute Gateway:** `omniroute` (Inference gateway on port `20128`)
2. **Graphify Watcher:** `python3 -m graphify watch` (Automated knowledge graph indexing into Second Brain)
3. **Claude Code Agent:** `claude`

> [!NOTE]
> * **Claude vs. Hermes:** The workspace currently auto-launches Claude Code (`claude`), not Hermes. Hermes can be added or substituted as a task if desired.
> * **Workspace Scope:** `.vscode/tasks.json` is scoped to this project folder. In other project folders, tasks will not run automatically unless `.vscode/tasks.json` is copied over or configured in User tasks (`~/Library/Application Support/Code/User/tasks.json`).

---

## 4. Integration with Second Brain & OmniRoute
* **[[Master_Architecture]]:** Part of the local AI tool stack hosted on `300web@Macmini`.
* **OmniRoute Gateway:** Hermes can route LLM calls through OmniRoute's local endpoint (`http://localhost:20128/v1`).
* **Knowledge Ingestion:** Notes created in this Obsidian vault are automatically indexed by `graphify watch` into the local second brain graph (`graphify-out`).
