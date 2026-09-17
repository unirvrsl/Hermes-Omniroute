#!/usr/bin/env bash
# ==============================================================================
# Hermes-Omniroute Station Setup / Bootstrap Script
# ==============================================================================
# Run this script on any new workstation to install all prerequisites, tools,
# and agents required for this workspace.
#
# Usage:
#   chmod +x setup.sh
#   ./setup.sh
# ==============================================================================

set -euo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}====================================================${NC}"
echo -e "${CYAN}   Hermes-Omniroute Station Bootstrap Installer     ${NC}"
echo -e "${CYAN}====================================================${NC}"

# 1. System Requirements Check
echo -e "\n${YELLOW}[1/4] Checking core system requirements...${NC}"

if ! command -v git &>/dev/null; then
    echo -e "${RED}Error: 'git' is not installed. Please install Git first.${NC}"
    exit 1
fi

if ! command -v node &>/dev/null || ! command -v npm &>/dev/null; then
    echo -e "${RED}Error: Node.js / npm is not installed.${NC}"
    echo -e "Please install Node.js (via Homebrew on macOS: 'brew install node', or via https://nodejs.org)."
    exit 1
fi
echo -e "${GREEN}✓ Node.js $(node -v) & npm $(npm -v) detected.${NC}"

if ! command -v python3 &>/dev/null; then
    echo -e "${RED}Error: Python 3 is not installed.${NC}"
    echo -e "Please install Python 3.11 or newer."
    exit 1
fi
echo -e "${GREEN}✓ Python $(python3 --version) detected.${NC}"

# 2. Install / Verify OmniRoute
echo -e "\n${YELLOW}[2/4] Verifying OmniRoute Gateway...${NC}"
if command -v omniroute &>/dev/null; then
    echo -e "${GREEN}✓ OmniRoute is already installed: $(omniroute --version 2>/dev/null || echo 'available')${NC}"
else
    echo -e "Installing OmniRoute globally via npm..."
    npm install -g omniroute
    echo -e "${GREEN}✓ OmniRoute installed successfully.${NC}"
fi

# 3. Install / Verify Graphify Watcher
echo -e "\n${YELLOW}[3/4] Verifying Graphify knowledge graph tool...${NC}"
if python3 -m graphify --help &>/dev/null; then
    echo -e "${GREEN}✓ Graphify is already installed.${NC}"
else
    echo -e "Installing graphifyy via pip..."
    python3 -m pip install --upgrade graphifyy --break-system-packages 2>/dev/null || python3 -m pip install --upgrade graphifyy
    echo -e "${GREEN}✓ Graphify installed successfully.${NC}"
fi

# 4. Install / Verify Hermes Agent
echo -e "\n${YELLOW}[4/4] Verifying Hermes Agent...${NC}"
mkdir -p "$HOME/.local/bin"

if command -v hermes &>/dev/null; then
    echo -e "${GREEN}✓ Hermes Agent is already installed: $(which hermes)${NC}"
else
    echo -e "Setting up Hermes Agent in $HOME/.hermes/hermes-agent..."
    mkdir -p "$HOME/.hermes"
    if [ ! -d "$HOME/.hermes/hermes-agent" ]; then
        git clone https://github.com/NousResearch/hermes-agent.git "$HOME/.hermes/hermes-agent"
    fi
    (
        cd "$HOME/.hermes/hermes-agent"
        chmod +x setup-hermes.sh
        ./setup-hermes.sh
    )
    echo -e "${GREEN}✓ Hermes Agent installation completed.${NC}"
fi

# Verify PATH for ~/.local/bin
CURRENT_SHELL_PROFILE=""
if [[ "$SHELL" == */zsh* ]]; then
    CURRENT_SHELL_PROFILE="$HOME/.zshrc"
elif [[ "$SHELL" == */bash* ]]; then
    CURRENT_SHELL_PROFILE="$HOME/.bashrc"
fi

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "\n${YELLOW}Notice: '$HOME/.local/bin' is not in your current PATH.${NC}"
    if [ -n "$CURRENT_SHELL_PROFILE" ]; then
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$CURRENT_SHELL_PROFILE"
        echo -e "${GREEN}Added ~/.local/bin to $CURRENT_SHELL_PROFILE.${NC}"
        echo -e "Run 'source $CURRENT_SHELL_PROFILE' or open a new terminal."
    fi
fi

echo -e "\n${CYAN}====================================================${NC}"
echo -e "${GREEN}✔ All components installed and verified!${NC}"
echo -e "${CYAN}====================================================${NC}"
echo -e "You can now launch VS Code in this directory:"
echo -e "  code .\n"
echo -e "The background tasks ('Hi Freddie') will automatically start:"
echo -e "  1. OmniRoute Gateway (port 20128)"
echo -e "  2. Graphify Watcher (indexing into Second Brain)"
echo -e "  3. Hermes Agent (interactive agent session)\n"
