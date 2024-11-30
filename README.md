# YSomic's NixOS Configuration

This repository contains a NixOS system configuration using the Flakes feature. It manages both system-level (NixOS) and user-level (Home Manager) configurations.

## 📁 Structure

```
.
├── configuration/       # Shared configurations between NixOS and Home Manager
│   ├── nixos/          # NixOS-specific configurations
│   └── home-manager/   # Home Manager-specific configurations
├── hosts/              # Host-specific NixOS configurations
│   ├── anchor/         # Configuration for 'anchor' machine
│   └── wanderer/       # Configuration for 'wanderer' machine (WIP)
├── home-manager/       # Host-specific Home Manager configurations
│   └── anchor/        # Configuration for the user on 'anchor'
├── modules/           # Custom NixOS and Home Manager modules
│   ├── nixos/        # NixOS-specific modules
│   ├── home-manager/ # Home Manager-specific modules
│   └── shared/       # Shared module definitions
├── pkgs/             # Custom package definitions
└── lib/              # Helper functions and documentation
    └── repl.md       # Guide for using the Nix REPL with this configuration
```

## 🚀 Features

- **Hyprland** Wayland compositor setup with:
  - Waybar configuration
  - Custom lock screen (Hyprlock)
  - Automatic multi-monitor setup
- **Theme Integration** with Catppuccin
- **Development Environment** with:
  - NVIM & VSCode
  - Git configuration
  - Custom terminal setup (Kitty)
- **Gaming Support** with Steam and Prismlauncher
- **Custom Scripts** for:
  - Power management
  - Window management
  - Git operations
  - Screenshot capabilities
  - Listing all files, useful for AI

## 🛠 Usage

### Prerequisites

1. NixOS installation with Flakes enabled
2. Git

### Development

For development and debugging, you can use the provided REPL setup:
- Check out the [REPL Guide](./lib/repl.md) for detailed usage instructions
- Use the `just -l` command for common operations:
  ```bash
  just         # Show available commands
  just rebuild # Rebuild NixOS configuration
  just hm      # Rebuild Home Manager configuration
  ```

## ⚙️ Configuration

### Adding a New Host

1. Create a new directory under `hosts/`
2. Copy and modify the hardware configuration
3. Create host-specific configurations

### Modifying Home Manager

User-specific configurations are managed in:
- `home-manager/anchor/` for the anchor machine
- `configuration/home-manager/` for shared configurations

### Custom Modules

Create new modules in `modules/` following the existing structure:
- `modules/nixos/` for NixOS modules
- `modules/home-manager/` for Home Manager modules
- `modules/shared/` for shared module definitions

## 🤝 Credits

This configuration is inspired by and borrows from:
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles/)
- [allowed unfree polyfill](https://discourse.nixos.org/t/use-nixpkgs-config-allowunfreepredicate-in-multiple-nix-file/36590)

## 🔍 Useful Resources
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Hyprland Documentation](https://wiki.hyprland.org/)

# Bootstrapping

*Work in progress*
- Create system agenix ssh key called /etc/HOSTNAME/agenix/agenix_HOSTNAME_system
    - Copy public key in `data/secrets/secrets.nix`
- Create user ssh key called ~/.config/agenix/agenix_key
    - Since we don't have the user yet, we might need to move it around after first activation
    - Add it to public keys here
- Rekey all secrets so that the keys can read em
- Get keepass bootstrap for Google PW + download keepass
- Be able to use rsa_id
