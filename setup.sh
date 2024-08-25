#!/bin/bash

# Configuration
REPO_URL="https://github.com/lx-0/project-templates.git"
INSTALL_DIR="$HOME/.project-templates"
CLI_NAME="project-cli"
CLI_PATH="$INSTALL_DIR/bin/$CLI_NAME"
VERBOSE=false

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m' # No color

# Function to handle errors with detailed output
handle_error() {
  echo -e "${RED}Error: $1${NC}"
  [ -n "$2" ] && echo -e "${RED}$2${NC}"
  exit 1
}

# Function to run a command silently with optional dim output
run_command_silently() {
  local output
  output=$("$@" 2>&1)
  local status=$?

  if [ "$VERBOSE" = true ]; then
    echo -e "${DIM}${output}${NC}"
  fi

  if [ $status -ne 0 ]; then
    handle_error "Failed to run the command: $*" "$output"
  fi

  return $status
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
  --verbose) VERBOSE=true ;;
  *) handle_error "Unknown parameter passed: $1" ;;
  esac
  shift
done

# Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
  echo -e "${YELLOW}Updating the project-templates repository...${NC}"
  run_command_silently git -C "$INSTALL_DIR" pull || exit 1
else
  echo -e "${YELLOW}Cloning the project-templates repository...${NC}"
  run_command_silently git clone "$REPO_URL" "$INSTALL_DIR" || exit 1
fi

# Ensure the CLI script exists
if [ ! -f "$CLI_PATH" ]; then
  handle_error "CLI script not found at $CLI_PATH. The repository may not have been cloned successfully."
fi

# Make the CLI script executable
run_command_silently chmod +x "$CLI_PATH" || handle_error "Failed to make the CLI executable."

# Determine the correct shell configuration file
if [[ "$SHELL" == */zsh ]]; then
  SHELL_CONFIG="$HOME/.zshrc"
  SHELL_CONFIG_SHORT="~/.zshrc"
else
  SHELL_CONFIG="$HOME/.bashrc"
  SHELL_CONFIG_SHORT="~/.bashrc"
fi

# Add the CLI to the user's PATH
if ! grep -q "$INSTALL_DIR/bin" "$SHELL_CONFIG"; then
  echo -e "\n# Add project-cli to PATH for easier access to project templates" >>"$SHELL_CONFIG"
  echo "export PATH=\$PATH:$INSTALL_DIR/bin" >>"$SHELL_CONFIG" || handle_error "Failed to add $INSTALL_DIR/bin to PATH."
  echo -e "${GREEN}Added $INSTALL_DIR/bin to PATH in $SHELL_CONFIG_SHORT.${NC}"
else
  echo -e "${YELLOW}$INSTALL_DIR/bin is already in your PATH.${NC}"
fi

echo -e "${GREEN}Setup complete. You can now run '${CLI_NAME}' from anywhere.${NC}"
echo -e "${YELLOW}Please restart your terminal or run 'source $SHELL_CONFIG_SHORT' to apply the changes.${NC}"
