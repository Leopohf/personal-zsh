# Personal Zsh Configuration

This repository contains a portable, modular Zsh configuration based on **Oh My Zsh** and the **Powerlevel10k**-inspired custom theme `leonardo`.

## Features
- **Modular Structure**: Configuration is split into `aliases`, `exports`, and `functions`.
- **Custom Theme**: `leonardo.zsh-theme` (Customized robbyrussell with Git and Node.js info).
- **Auto-Installation**: A script to set up everything on a new machine.
- **Java Management**: Integrated [SDKMAN!](https://sdkman.io/) with automatic version switching.

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
   chmod +x install.sh
   ./install.sh
   ```

3. Restart your terminal or run:
   ```bash
   source ~/.zshrc
   ```

## Structure
- `zshrc.template`: The main entry point linked to `~/.zshrc`.
- `config/`: Modular `.zsh` files sourced automatically.
- `themes/`: Custom Zsh themes.
- `install.sh`: Setup script for dependencies and symlinks.

