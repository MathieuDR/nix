# Nix REPL Guide

## Basic Usage

Start the REPL in your flake directory:
```bash
repl .
```

## Common Configurations

### Home Manager
Access home-manager configurations:
```nix
homeConfigurations."user@hostname"
```

Useful aliases for easier access:
```nix
cfg = homeConfigurations."user@hostname".config
```

### NixOS
Access NixOS configurations:
```nix
nixosConfigurations.hostname
```

Useful aliases:
```nix
cfg = nixosConfigurations.hostname.config
```

## Configuration Structure

### Home Manager Structure
- `config` - Contains the evaluated configuration
  - `home` - Basic home configuration (username, homeDirectory, etc.)
  - `services` - All service configurations
  - `programs` - All program configurations
  - `systemd` - Systemd user service configurations
- `options` - Available configuration options
- `pkgs` - Access to nixpkgs
- `extendModules` - Function to extend the configuration
- `activationPackage` - The derivation that activates the configuration

Examples:
```nix
# Basic home config
cfg.home.username
cfg.home.homeDirectory

# Services (NOT cfg.home.services)
cfg.services.dunst.enable
cfg.services.picom.enable

# Programs
cfg.programs.git.enable
cfg.programs.vim.enable
```

### NixOS Structure
- `config` - Contains the evaluated configuration
  - `services` - System services
  - `systemd` - Systemd configurations
  - `networking` - Network configurations
  - `hardware` - Hardware configurations
- `options` - Available configuration options
- `pkgs` - Access to nixpkgs

## Exploring Configurations

List available attributes:
```nix
# List all attributes in a configuration section
builtins.attrNames cfg.services
builtins.attrNames cfg.programs
builtins.attrNames cfg.home

# List all options
builtins.attrNames cfg.options

# Explore specific service options
builtins.attrNames cfg.services.dunst
```

## Common Errors

### Missing Attributes
Error: `error: attribute 'xyz' missing`
- Check if you're looking in the correct location
- Services are under `config.services`, not `config.home.services`
- Use `builtins.attrNames` to see available attributes

### Deprecated Services
Error messages about removed services (e.g., `services.keepassx`) indicate:
- The service has been removed/deprecated
- Often includes information about replacements
- These errors appear when viewing all services but won't affect your configuration

## Tips & Tricks

### Tab Completion
- Press TAB after typing partial paths to see available options
- Works with both attribute names and values

### Testing Values
```nix
# Check if a service is enabled
cfg.services.dunst.enable

# Check program settings
cfg.programs.git.userEmail

# View entire configuration for a service
cfg.services.dunst
```

### Debugging

Check if values are being set correctly:
```nix
# View the entire configuration
cfg

# View specific sections
cfg.services
cfg.programs

# Check option definitions
cfg.options.services.dunst.enable.description
```

### Using with Flakes

View flake inputs:
```nix
inputs
inputs.nixpkgs
```

View flake outputs:
```nix
outputs
outputs.packages
```

### Useful Queries

Package exploration:
```nix
# View available packages
builtins.attrNames pkgs

# Check package version
pkgs.nodejs.version
```

System information:
```nix
# NixOS
cfg.networking.hostName
cfg.system.stateVersion

# Home Manager
cfg.home.stateVersion
cfg.home.username
```
