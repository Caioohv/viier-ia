#!/bin/bash

# Define formatting colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper for printing messages
info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

success() {
  echo -e "${GREEN}✓${NC} $1"
}

warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

error() {
  echo -e "${RED}✗${NC} $1"
}

show_help() {
  echo -e "Usage: $0 <target_directory> [options]"
  echo -e ""
  echo -e "Arguments:"
  echo -e "  target_directory   The path to the project where you want to initialize the AI agents."
  echo -e ""
  echo -e "Options:"
  echo -e "  -h, --help         Show this help message."
  echo -e ""
  echo -e "Example:"
  echo -e "  ./setup-agents.sh /path/to/my/project"
}

# --- Validation ---

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  show_help
  exit 0
fi

TARGET_DIR="$1"
PROMPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/prompts"

if [ ! -d "$TARGET_DIR" ]; then
  error "Target directory '$TARGET_DIR' does not exist."
  exit 1
fi

if [ ! -d "$PROMPTS_DIR" ]; then
  error "Prompts directory not found at '$PROMPTS_DIR'."
  warning "Please run this script from the root of your ia-setup project."
  exit 1
fi

# --- Execution ---

AGENT_DIR="$TARGET_DIR/.agent-files"
TARGET_PROMPTS_DIR="$AGENT_DIR/prompts"

info "Initializing agent structure in: $TARGET_DIR"

# 1. Create directory structure
info "Creating .agent-files hierarchy..."
mkdir -p "$AGENT_DIR/context"
mkdir -p "$AGENT_DIR/tasks/pending"
mkdir -p "$AGENT_DIR/tasks/done"
success "Directories created."

# 2. Touch base context files
info "Initializing base context files..."
touch "$AGENT_DIR/context/spec.md"
touch "$AGENT_DIR/context/memory.md"
touch "$AGENT_DIR/context/goals.md"
success "Context files created."

# 3. Copy Prompts (Optional but recommended)
# We copy them so the specific project can tweak its own agent roles over time if needed.
info "Copying agent prompt definitions..."
mkdir -p "$TARGET_PROMPTS_DIR"
cp "$PROMPTS_DIR/plan.md" "$TARGET_PROMPTS_DIR/"
cp "$PROMPTS_DIR/develop.md" "$TARGET_PROMPTS_DIR/"
cp "$PROMPTS_DIR/review.md" "$TARGET_PROMPTS_DIR/"
cp "$PROMPTS_DIR/contextualizer.md" "$TARGET_PROMPTS_DIR/"
success "Prompts copied to $TARGET_PROMPTS_DIR."

echo -e ""
success "Setup complete! 🚀"
echo -e "${YELLOW}Next Steps:${NC}"
echo -e "1. Open ${BLUE}$TARGET_DIR/.agent-files/context/goals.md${NC} and define the project vision."
echo -e "2. Run the ${GREEN}Contextualizer Agent${NC} to start mapping your architecture."
echo -e "3. Give the ${GREEN}Plan Agent${NC} its first task!"
