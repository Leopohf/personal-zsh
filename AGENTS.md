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
- **Logic**: Detects OS, installs dependencies, copies config files to `~/.zsh_config/`, and manages `.zshrc` backups.

### Modular Configuration
- **Structure**: The `config/` directory is organized into subdirectories for better management:
    - **`config/core/`**: Essential system and environment configurations.
        - `00-os.zsh`: Centralized OS detection and icon definition.
        - `macos.zsh`: macOS-specific technical adjustments.
    - **`config/plugins/`**: Functional modules and tool-specific configurations.
        - `aliases.zsh`: General purpose aliases.
        - `exports.zsh`: General environment variables.
        - `extract.zsh`: Universal extraction function.
        - `history.zsh`: Zsh history optimization.
        - `brew.zsh`: Homebrew setup.
        - `fnm.zsh`, `bun.zsh`, `sdkman.zsh`, `docker.zsh`, `cloud.zsh`, `ng.zsh`, `wd.zsh`: Tool-specific configs.
        - `zsh-plugins.zsh`: Autosuggestions and Syntax Highlighting config.
- **Deployment**: `install.sh` copies all files from both subdirectories to `~/.zsh_config/` in a **flat structure**.
- The `zshrc.template` automatically sources everything in `~/.zsh_config/*.zsh`.
- **Rule**: Never modify `~/.zshrc` directly for permanent changes; add/edit files in the appropriate `config/` subdirectory.
- **Rule**: Each plugin, tool, or logical set of configurations **MUST** have its own dedicated `.zsh` file in the `config/plugins/` or `config/core/` directory.

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
