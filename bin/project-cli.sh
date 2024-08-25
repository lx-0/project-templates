#!/bin/bash

# Configuration
REPO_URL="https://github.com/lx-0/project-templates.git"
LOCAL_REPO_DIR="$HOME/.project-templates"
TEMPLATES_DIR="$LOCAL_REPO_DIR/templates"
COMMON_DIR="$LOCAL_REPO_DIR/common"

# Ensure the repository is up-to-date
if [ -d "$LOCAL_REPO_DIR" ]; then
  git -C "$LOCAL_REPO_DIR" pull
else
  git clone "$REPO_URL" "$LOCAL_REPO_DIR"
fi

# Function to display help
show_help() {
  echo "Usage: project-cli [-t template] [-n project_name] [-f features]"
  echo ""
  echo "  -t, --template        The project template to use"
  echo "  -n, --name            The name of the new project"
  echo "  -f, --features        Features to integrate (comma-separated)"
  echo "  -h, --help            Display this help message"
}

# Function to list available templates
list_templates() {
  echo "Available project templates:"
  for dir in "$TEMPLATES_DIR"/*/; do
    echo "  - $(basename "$dir")"
  done
}

# Function to integrate a feature
integrate_feature() {
  FEATURE_PATH="$COMMON_DIR/$1"
  if [ -d "$FEATURE_PATH" ]; then
    echo "Integrating $1..."
    cp -R "$FEATURE_PATH/." "$CURRENT_DIR/$project_name"
  else
    echo "Feature $1 not found."
  fi
}

# Interactive template selection
select_template() {
  echo "Available project templates:"
  templates=()
  index=1
  for dir in "$TEMPLATES_DIR"/*/; do
    template=$(basename "$dir")
    echo "$index) $template"
    templates+=("$template")
    index=$((index + 1))
  done

  read -p "Select a project template by number: " template_index
  template="${templates[$((template_index - 1))]}"

  if [ -z "$template" ]; then
    echo "Invalid selection. Exiting."
    exit 1
  fi
}

# Interactive feature selection
select_features() {
  echo "Available features:"
  features=()
  index=1
  for dir in "$COMMON_DIR"/*/; do
    feature=$(basename "$dir")
    echo "$index) $feature"
    features+=("$feature")
    index=$((index + 1))
  done

  read -p "Enter the numbers of the features you want to integrate (space-separated): " -a selections

  selected_features=()
  for i in "${selections[@]}"; do
    if [[ "$i" =~ ^[0-9]+$ ]] && ((i >= 1 && i <= ${#features[@]})); then
      selected_features+=("${features[$((i - 1))]}")
    else
      echo "Invalid selection: $i"
    fi
  done
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
  -t | --template)
    template="$2"
    shift
    ;;
  -n | --name)
    project_name="$2"
    shift
    ;;
  -f | --features)
    features="$2"
    shift
    ;;
  -h | --help)
    show_help
    exit 0
    ;;
  *)
    echo "Unknown parameter passed: $1"
    show_help
    exit 1
    ;;
  esac
  shift
done

# If not provided via arguments, ask for template and project name
if [ -z "$template" ]; then
  select_template
fi

if [ -z "$project_name" ]; then
  read -p "Enter the name of the new project: " project_name
fi

# Create the project directory in the current directory
CURRENT_DIR=$(pwd)
if [ -d "$TEMPLATES_DIR/$template" ]; then
  cp -R "$TEMPLATES_DIR/$template" "$CURRENT_DIR/$project_name"
  echo "Project '$project_name' created based on template '$template' in $CURRENT_DIR."
else
  echo "Error: Template '$template' not found."
  list_templates
  exit 1
fi

# If not provided via arguments, ask for features interactively
if [ -z "$features" ]; then
  select_features
else
  IFS=',' read -ra selected_features <<<"$features"
fi

# Integrate selected features
for feature in "${selected_features[@]}"; do
  integrate_feature "$feature"
done

echo "Project setup complete."
