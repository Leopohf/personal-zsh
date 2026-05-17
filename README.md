# Personal Zsh Configuration

This repository contains a portable, modular Zsh configuration based on **Oh My Zsh** and the **Powerlevel10k**-inspired custom theme `leonardo`.

## Features
- **Granular Installation**: Choose exactly which tools and plugins to install (Git, GitHub CLI, Node, pnpm, Bun, Docker, AWS, Azure, Angular, Go, Maven, etc.) independently via an interactive menu.
- **Enhanced Terminal Experience**: Includes pre-configured support for **Zsh Autosuggestions**, **Syntax Highlighting**, and **Fzf** (Fuzzy Finder).
- **Homebrew Integration**: Automatically installs missing CLI tools using Homebrew for a seamless setup.
- **Modular Structure**: Configuration is split into specialized subdirectories. Only the configurations for selected features are deployed.
- **Dynamic Plugin Management**: Automatically generates the Oh My Zsh plugin list based on your preferences.
- **Custom Theme**: `leonardo.zsh-theme` (Customized robbyrussell with dynamic OS icons).
- **Java Management**: Integrated [SDKMAN!](https://sdkman.io/) with automatic version switching.
- **Utility Tools**: Includes handy utilities like **Extract** (one command to unzip anything) and **Warp Directory (wd)** for quick navigation.

## Mandatory Dependencies

Some features have mandatory dependencies for security or functional reasons:

- **Angular CLI**: Requires global installation via `pnpm`. You must agree to this during the installation process.
- **Docker**: Enabling Docker support requires the installation of `Docker Compose`.

## Java & SDKMAN!

This configuration includes a dedicated module for managing Java versions via SDKMAN!.

### Features:
- **Auto-Install**: The `install.sh` script automatically installs SDKMAN! if it's not present.
- **Auto-Env**: Configured by default to switch Java versions automatically when entering a directory with a `.sdkmanrc` file.
- **Helper Function**: Use `jv` as a shortcut for Java version management.

### Usage:
- `jv`: Displays the current Java version.
- `jv <version>`: Switches to a specific Java version (e.g., `jv 17-tem`).
- `sdk env init`: Creates a `.sdkmanrc` file in the current directory to lock the Java version for a project.

## Installation

1. Clone this repository to your preferred location:
   ```bash
   git clone https://github.com/your-username/personal-zsh.git ~/personal-zsh
   ```

2. Run the installation script:
   ```bash
   cd ~/personal-zsh
   # Grant execution permissions to the installer and its modules
   chmod +x install.sh scripts/install/*.sh
   ./install.sh
   ```
   *Note: The script may prompt for your password to install Homebrew or system dependencies via `sudo`.*

3. Restart your terminal or run:
   ```bash
   source ~/.zshrc
   ```

## Configuration Preferences

Your selected features are stored in `.zsh_plugins.env`. You can manually edit this file to enable or disable features and then re-run `./install.sh`.

Example `.zsh_plugins.env`:
```bash
ENABLE_GH=true
ENABLE_FNM=true
ENABLE_PNPM=true
ENABLE_NG=true
ENABLE_DOCKER=true
ENABLE_DOCKER_COMPOSE=true
ENABLE_AUTOSUGGEST=true
ENABLE_HIGHLIGHT=true
...
```

## Sensitive Data & API Keys

To keep your secrets safe and avoid committing them to a repository, this project uses a local file: `~/.zshrc.local`.

- **Security**: This file is created with restricted permissions (`chmod 600`) so only you can read it.
- **Persistence**: It is NOT tracked by Git and is NOT overwritten when you re-run the `install.sh` script.
- **Usage**: Use it to export sensitive environment variables, such as API keys or personal tokens.

### How to use it:

1. Open the file:
   ```bash
   nvim ~/.zshrc.local
   ```
2. Add your exports:
   ```zsh
   export OPENAI_API_KEY="your-secret-key"
   export GITHUB_TOKEN="your-personal-token"
   ```
3. Reload your terminal:
   ```bash
   source ~/.zshrc
   ```

## Testing

This project uses [Bats (Bash Automated Testing System)](https://github.com/bats-core/bats-core) for unit and integration testing of the shell scripts.

### Running Tests Locally

Tests are managed via `pnpm`. To run the full test suite:

1. Install testing dependencies:
   ```bash
   pnpm install
   ```
2. Execute the tests:
   ```bash
   pnpm test
   ```

### Testing Strategy

- **Mocking**: System-altering commands like `brew`, `git`, `curl`, and `unzip` are mocked during testing to prevent actual modifications to your local environment.
- **Dry Run**: The main `install.sh` supports a `--dry-run` flag which allows the script to be safely executed within tests to verify the entry-point logic and modular loading.
- **Isolation**: Tests utilize `$BATS_TMPDIR` to create temporary home directories and configuration files, ensuring that your actual system configuration remains untouched.

### Continuous Integration

A GitHub Actions pipeline is configured to automatically run the test suite on every push and pull request. The pipeline tests the configuration across:
- **Ubuntu** (Latest)
- **macOS** (Latest)
- **Windows** (via **WSL** Ubuntu-22.04)

## Structure
- `zshrc.template`: The main entry point copied to `~/.zshrc`.
- `install.sh`: Main entry point for the installation process.
- `scripts/install/`: Modular installation scripts (features, dependencies, configuration).
- `config/`: 
    - `core/`: Base system configurations (OS detection, history, aliases).
    - `plugins/`: Tool-specific and functional configurations (Brew, Docker, SDKMAN, etc.).
- `themes/`: Custom Zsh themes copied to Oh My Zsh custom themes folder.

## Nerd Font Symbols

This configuration relies on **Nerd Font Symbols** to display icons for the OS, Git, and other tools.

### Installation
The `install.sh` script automatically installs the necessary fonts:
- **macOS**: Installed to `~/Library/Fonts`.
- **Linux**: Installed to `~/.local/share/fonts`.

> **Note for Linux**: We have disabled the automatic `fontconfig` rule because it can make some fonts appear thicker or in bold. We recommend manual configuration in your terminal settings (see below).

### Terminal Configuration

If icons (like the Apple or Linux logo) do not appear correctly, you may need to manually configure your terminal to use **Symbols Nerd Font Mono** as a fallback.

#### VS Code
Add the following to your `settings.json`:
```json
"terminal.integrated.fontFamily": "'Symbols Nerd Font Mono', 'Your favorite monospace font'",
```

#### Ghostty
Ghostty usually detects the symbols font automatically. If it doesn't, add it to your configuration (`~/.config/ghostty/config`):
```text
font-family = "Your Main Font"
font-family = "Symbols Nerd Font Mono"
```

#### iTerm2 (macOS)
1. Open **Settings** > **Profiles** > **Text**.
2. Check **Use a different font for non-ASCII text**.
3. Select **Symbols Nerd Font Mono**.

#### Other Terminals (Alacritty, Kitty)
Most modern terminals will pick up the font automatically if it's installed in the system. If you see boxes, ensure the font is correctly named `Symbols Nerd Font Mono` in your configuration file.
