# Shared Agent Reference: personal-zsh

This file provides core context and guidelines for AI agents (Gemini, Claude, etc.) working on the `personal-zsh` project.

## Core Project Context
- **Purpose**: Portable, modular Zsh configuration for Linux, macOS, and WSL.
- **Base**: Oh My Zsh.
- **Custom Theme**: `leonardo.zsh-theme` (requires `OS_ICON` env var; includes git stats with yellow document icon `󰈙` and yellow lines icon ``).
- **Package Managers & Tools**: 
    - **SDKMAN!** (`config/sdkman.zsh`): Java version management.
    - **FNM** (`config/fnm.zsh`): Fast Node Manager.
    - **Bun** (`config/bun.zsh`): JavaScript runtime and manager.
    - **Homebrew** (`config/brew.zsh`): Package manager for macOS and Linux.
    - **Git LFS** (`config/plugins/git-lfs.zsh`): Git Large File Storage configuration and aliases.

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
- Auto-installs Java 21 (`21-tem`) upon SDKMAN! installation.
- Use `.sdkmanrc` for project-specific versions.

### Theming
- Icons are dynamic based on the `OS_ICON` variable defined in `config/core/00-os.zsh`.

## Tool-Specific Guidance

All agent configuration lives under `.agents/`. Shared skills are in `.agents/skills/`.

### Gemini
- **Tooling**: Prioritize the use of `grep_search` to find modular configurations in `config/` before suggesting changes.
- **Verification**: When testing shell script changes, use `run_shell_command` with `zsh -n <file>` to check for syntax errors.
- **Context**: Remember that `zshrc.template` is the source of truth for the linked `~/.zshrc`.

### Claude
- **Environment**: Be mindful of the modular nature of the config when providing code snippets.
- **Paths**: Always use absolute paths or relative paths based on the project root when suggesting commands.

## Agent Mandates

### Documentation Maintenance
- **Mandatory Update**: Every time an agent makes a functional or structural change to the project, they **MUST** immediately update:
    - `README.md`: To ensure user-facing documentation is current.
    - `.agents/AGENTS.md`: To ensure shared context for other agents remains accurate.
- **Consistency**: Ensure that technical details (aliases, paths, features) are synchronized across all documentation files.

## Maintenance
- **Reload**: `reload` alias.
- **Edit**: `zshconfig` alias.
