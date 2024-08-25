#!/bin/bash

# Configuration
REPO_URL="https://github.com/lx-0/project-templates.git"
INSTALL_DIR="$HOME/.project-templates"
CLI_NAME="project-cli"
CLI_PATH="$INSTALL_DIR/bin/$CLI_NAME"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
DIM='\033[2m'
NC='\033[0m' # No color

# Function to handle errors
handle_error() {
  echo -e "${RED}Error: $1${NC}"
  exit 1
}

# Function to run a command and apply dim color to its output
run_command_with_dim_output() {
  local output
  output=$("$@" 2>&1)
  local status=$?
  echo -e "${DIM}${output}${NC}"
  return $status
}

# Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
  echo -e "${YELLOW}Updating the existing project-templates repository...${NC}"
  run_command_with_dim_output git -C "$INSTALL_DIR" pull || handle_error "Failed to update the repository."
else
  echo -e "${YELLOW}Cloning the project-templates repository...${NC}"
  run_command_with_dim_output git clone "$REPO_URL" "$INSTALL_DIR" || handle_error "Failed to clone the repository. Please check the URL: $REPO_URL"
fi

# Ensure the CLI script exists
if [ ! -f "$CLI_PATH" ]; then
  handle_error "CLI script not found at $CLI_PATH. The repository may not have been cloned successfully."
fi

# Make the CLI script executable
chmod +x "$CLI_PATH" || handle_error "Failed to make the CLI executable."

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
  echo "export PATH=\$PATH:$INSTALL_DIR/bin" >>"$SHELL_CONFIG" || handle_error "Failed to add $INSTALL_DIR/bin to PATH."
  echo -e "${GREEN}Added $INSTALL_DIR/bin to PATH in $SHELL_CONFIG_SHORT.${NC}"
else
  echo -e "${YELLOW}$INSTALL_DIR/bin is already in your PATH.${NC}"
fi

echo -e "${GREEN}Setup complete. You can now run '${CLI_NAME}' from anywhere.${NC}"
echo -e "${YELLOW}Please restart your terminal or run 'source $SHELL_CONFIG_SHORT' to apply the changes.${NC}"
