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
└── pkgs/             # Custom package definitions
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
- [**Power management**](POWER.md)
- **Custom Scripts** for:
  - Power management
  - Window management
  - Git operations
  - Screenshot capabilities
  - Listing all files, useful for AI

## 📝 Planned Improvements

See [TODOs.md](./TODOs.md) for a list of planned improvements and additions to this configuration, including:
- Automatic garbage collection
- Backup configuration
- System maintenance
- Security enhancements
- And more...

These improvements are tracked and documented to maintain system health and add useful features over time.

## 🛠 Usage

### Prerequisites

1. NixOS installation with Flakes enabled
2. Git

### Development

For development and debugging, you can use the provided REPL setup:
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
- [Scott Worley's nix-profile-gc](https://git.scottworley.com/nix-profile-gc)

## 🔍 Useful Resources
- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Hyprland Documentation](https://wiki.hyprland.org/)

# Bootstrapping

*Work in progress*
- Create system agenix ssh key called /etc/HOSTNAME/agenix_HOSTNAME_system
    - Copy public key in `data/secrets/secrets.nix`
- Create user ssh key called ~/.config/agenix/agenix_key
    - Since we don't have the user yet, we might need to move it around after first activation
    - Add it to public keys here
- Rekey all secrets so that the keys can read em
- Get keepass bootstrap for Google PW + download keepass
- Be able to use rsa_id

## WANDERER
- Installed using gnome installer
- Copied /etc/nixos/* configuration
- Imported in configuration
- Activate using flake
    - `sudo nixos-rebuild switch --flake github:MathieuDR/nix#HOST --refresh`
    - `sudo home-manager switch --flake github:MathieuDR/nix#USER@HOST --refresh`
- Create system keys with `just generate-keys`
    - Use the CP argument to copy the public keys, ready to be added to the config
- Syncthing
    - Gather device id `syncthing generate`
    - add it to `configuration/home-manager/syncthing.nix`
- Firefox
    - Install [firefox](https://github.com/catppuccin/firefox) colour theme
    - User styles, sync from cloud
    - STG, import latest backup under `~/.config/<HOST>/firefox/STG.backup`
