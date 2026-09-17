# Hermes-Omniroute Workspace

A self-contained AI Agent and Second Brain workspace combining **NousResearch Hermes Agent**, **OmniRoute Gateway**, and **Graphify** knowledge graph indexing for Obsidian.

---

## Portability & Multi-Station Setup

When cloning this repository to another workstation or server via Git, run the included bootstrap script to automatically install all dependencies and binaries.

### Prerequisites (on target station)
* **Git**
* **Node.js** (v18+) & **npm**
* **Python** (3.11+)

### 1-Step Setup on Any New Machine
```bash
git clone <your-repo-url> Hermes-Omniroute
cd Hermes-Omniroute
./setup.sh
```

The script automatically:
1. Installs **OmniRoute** globally (`npm i -g omniroute`).
2. Installs **Graphify** (`python3 -m pip install graphifyy`).
3. Clones and configures **Hermes Agent** in `~/.hermes/hermes-agent` and links the CLI to `~/.local/bin/hermes`.
4. Ensures `~/.local/bin` is in your `$PATH`.

---

## Workspace Architecture

When opened in VS Code / Antigravity IDE, the default build task (`Hi Freddie`) automatically initializes:

1. **OmniRoute Gateway:** Local LLM routing gateway listening on `0.0.0.0:20128`.
2. **Graphify Watcher:** Continuously indexes `.md` files and workspace code into the Obsidian Second Brain (`graphify-out`).
3. **Hermes Agent:** Interactive terminal session (`hermes chat`) running directly within this workspace.

---

## Directory Structure

```text
Hermes-Omniroute/
├── .obsidian/                           # Obsidian Second Brain vault configuration
├── .vscode/
│   ├── settings.json                    # Workspace editor & automatic task triggers
│   └── tasks.json                       # Automated startup tasks (OmniRoute, Graphify, Hermes)
├── Hermes_Agent_Global_Availability.md   # Architectural documentation of Hermes Agent setup
├── setup.sh                             # Cross-station bootstrap installation script
├── README.md                            # Station setup & usage guide
└── Welcome.md                           # Obsidian vault welcome note
```

---

## Manual Execution (If needed)

If running outside of VS Code:
* **Start OmniRoute:** `omniroute`
* **Start Graphify Watcher:** `python3 -m graphify watch`
* **Start Hermes Agent:** `hermes chat`
