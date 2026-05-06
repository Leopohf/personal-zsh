# Personal Zsh Configuration

This repository contains a portable, modular Zsh configuration based on **Oh My Zsh** and the **Powerlevel10k**-inspired custom theme `leonardo`.

## Features
- **Modular Structure**: Configuration is split into specialized files (`aliases`, `brew`, `fnm`, `bun`, `sdkman`, `docker`, `cloud`, `history`, `zsh-plugins`, `ng`, `exports`).
- **Rich Plugin Support**: Pre-configured for Git, Docker, AWS, Azure, and more.
- **Improved Shell Experience**: Advanced history management and optimized syntax highlighting/autosuggestions.
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
