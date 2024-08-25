# Project Templates Repository

Welcome to the Project Templates Repository! This repository helps you quickly start new projects with predefined templates and features. It includes a CLI tool to automate the process of setting up a new project, selecting a template, and integrating common features like Git configuration, Prettier settings, and more.

## Table of Contents

- [Setup](#setup)
- [Creating a New Project](#creating-a-new-project)
- [Adding a Custom Template](#adding-a-custom-template)
- [Adding a New Feature](#adding-a-new-feature)
- [Directory Structure](#directory-structure)

## Setup

To set up the CLI, the preferred method is to use `curl` by running the following command:

```bash
curl -s https://raw.githubusercontent.com/lx-0/project-templates/main/setup.sh | bash
```

Alternatively, you can use `wget`:

```bash
wget -q -O - https://raw.githubusercontent.com/lx-0/project-templates/main/setup.sh | bash
```

This will clone the repository into `~/.project-templates`, make the CLI executable, and add it to your `PATH`. After running the setup script, please restart your terminal or run `source ~/.bashrc` (or `source ~/.zshrc` if using Zsh) to apply the changes.

### Verbose Mode

By default, the script runs in a quiet mode where command outputs are dimmed. If you want to see detailed output for all commands, you can use the `--verbose` flag:

```bash
./setup.sh --verbose
```

## Creating a New Project

To create a new project using one of the predefined templates:

### Interactive Mode

Run the following command:

```bash
project-cli
```

1. **Select a Project Template:**

   The script will list all available project templates. Choose the template you want by entering its corresponding number.

2. **Name Your New Project:**

   After selecting a template, you'll be prompted to enter a name for your new project. The script will create a new directory with this name in the current directory.

3. **Select Features to Integrate:**

   The script will then list available features (e.g., Git integration, Prettier config). You can select the features you want to include in your new project by typing their corresponding numbers, separated by spaces.

4. **Complete the Setup:**

   The selected features will be integrated into your new project, and the setup process will be completed automatically.

### Non-Interactive Mode

You can also run the script with command-line arguments to skip the interactive prompts:

```bash
project-cli -t node-template -n my-node-app -f git-integration,prettier-config
```

In this example, the `node-template` will be used to create a project named `my-node-app`, with `git-integration` and `prettier-config` features integrated.

## Adding a Custom Template

You can add your own custom templates to this repository by following these steps:

1. **Create a New Template Directory:**

   In the `templates` directory, create a new directory for your template. For example, to add a template for a Django project, create a directory named `django-template`.

   ```bash
   mkdir templates/django-template
   ```

2. **Add Template Files:**

   Populate the directory with the necessary files and structure for your template. This could include source code, configuration files, `README.md`, etc.

3. **Ensure Compatibility with the Script:**

   Make sure your template follows the general structure of existing templates so that it works seamlessly with the `project-cli.sh` script.

4. **Commit and Push:**

   Once your template is ready, commit your changes and push them to the repository.

   ```bash
   git add templates/django-template
   git commit -m "Add Django project template"
   git push origin main
   ```

### Example Structure

```plaintext
templates/django-template/
├── manage.py
├── requirements.txt
├── myapp/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
└── README.md
```

## Adding a New Feature

You can add new features that can be integrated into any project created from a template. Here’s how:

1. **Create a New Feature Directory:**

   Inside the `features/` directory, create a new directory for your feature. For example, to add ESLint configuration, create a directory named `eslint-config`.

   ```bash
   mkdir features/eslint-config
   ```

2. **Add Configuration Files:**

   Populate the feature directory with the relevant configuration files. For ESLint, this might include `.eslintrc.json`, `.eslintignore`, etc.

3. **Document the Feature:**

   Include a `README.md` in the feature directory to explain what the feature does and how it should be used.

4. **Commit and Push:**

   Once your feature is ready, commit your changes and push them to the repository.

   ```bash
   git add features/eslint-config
   git commit -m "Add ESLint configuration feature"
   git push origin main
   ```

### Example Structure

```plaintext
features/eslint-config/
├── .eslintrc.json
├── .eslintignore
└── README.md
```

## Directory Structure

Here’s an overview of the directory structure used in this repository:

```plaintext
project-templates/
│
├── features/                 # Contains shared features that can be integrated into any project
│   ├── vscode-settings/
│   ├── prettier-config/
│   ├── git-integration/
│   └── docker-config/
│
├── templates/
│   ├── node-template/        # Example project template for Node.js projects
│   ├── python-template/      # Example project template for Python projects
│   └── react-template/       # Example project template for React projects
│
├── bin/
│   └── project-cli.sh        # Script to create a new project and integrate features
└── README.md
```

## Contributing

Feel free to contribute by adding new templates or features. Make sure to follow the structure and guidelines provided in this `README.md` to ensure consistency across the repository.
