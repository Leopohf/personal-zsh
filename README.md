# Personal Zsh Configuration

This repository contains a portable, modular Zsh configuration based on **Oh My Zsh** and the **Powerlevel10k**-inspired custom theme `leonardo`.

## Features
- **Modular Structure**: Configuration is split into `aliases`, `exports`, and `functions`.
- **Custom Theme**: `leonardo.zsh-theme` (Customized robbyrussell with Git and Node.js info).
- **Auto-Installation**: A script to set up everything on a new machine.

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

