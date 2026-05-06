# Shared Agent Reference: personal-zsh

This file provides core context and guidelines for AI agents (Gemini, Claude, etc.) working on the `personal-zsh` project.

## Core Project Context
- **Purpose**: Portable, modular Zsh configuration for Linux, macOS, and WSL.
- **Base**: Oh My Zsh.
- **Custom Theme**: `leonardo.zsh-theme` (requires `OS_ICON` env var).
- **Package Managers**: 
    - **SDKMAN!** (`config/sdkman.zsh`): Java version management.
    - **FNM** (`config/fnm.zsh`): Fast Node Manager.
    - **Bun** (`config/bun.zsh`): JavaScript runtime and manager.
    - **Homebrew** (`config/brew.zsh`): Package manager for macOS and Linux.

## Key Workflows

### Installation
- **Entry point**: `install.sh`.
- **Modular Logic**: The installer is organized into scripts in `scripts/install/`:
    - `common.sh`: Shared variables and logging.
    - `features.sh`: Interactive feature selection and preference loading.
    - `deps.sh`: Installation of Homebrew, OMZ, and custom plugins.
    - `config.sh`: Deployment of themes, configs, and fonts.
- **Preferences**: Persists preferences in `.zsh_plugins.env`.

### Modular Configuration
- **Structure**: The `config/` directory is organized into subdirectories:
    - **`config/core/`**: Essential system configurations (always installed).
    - **`config/plugins/`**: Functional modules.
- **Selective Deployment**: `install.sh` copies files to `~/.zsh_config/` **selectively** based on the enabled features in `.zsh_plugins.env`.
- **Dynamic Plugins**: `zshrc.template` contains a `_DYNAMIC_PLUGINS_` placeholder that is replaced during installation with the list of Oh My Zsh plugins corresponding to the selected features.
- **Rule**: Never modify `~/.zshrc` directly; add/edit files in `config/`.
- **Rule**: Each tool or logical set **MUST** have its own `.zsh` file.

## Development Conventions

### Scripting
- Use Bash/Zsh compatible syntax.
- Use `[[ -s "file" ]]` for existence and size checks.

### Java (SDKMAN!)
- Use the `jv` helper function for version switching.
- Use `.sdkmanrc` for project-specific versions.

### Theming
- Icons are dynamic based on the `OS_ICON` variable defined in `config/core/00-os.zsh`.

## Tool-Specific Instructions
Additional tool-specific guidance is available in:
- **Gemini**: `.gemini/GEMINI.md`
- **Claude**: `.claude/CLAUDE.md`

## Agent Mandates

### Documentation Maintenance
- **Mandatory Update**: Every time an agent makes a functional or structural change to the project, they **MUST** immediately update:
    - `README.md`: To ensure user-facing documentation is current.
    - `AGENTS.md`: To ensure shared context for other agents remains accurate.
    - **Tool-specific MDs**: If the change affects tool-specific workflows (e.g., new `grep` patterns for Gemini).
- **Consistency**: Ensure that technical details (aliases, paths, features) are synchronized across all documentation files.

## Maintenance
- **Reload**: `reload` alias.
- **Edit**: `zshconfig` alias.
