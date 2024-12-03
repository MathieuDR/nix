# Define the default recipe to list available commands
default:
    @just --list

_get_hosts:
    nix flake show --json | jq -r '.nixosConfigurations | keys[]' 2>/dev/null || echo "anchor"

# Helper recipe to get home-manager configurations
_get_hm_combinations:
    nix eval .#homeConfigurations --apply __attrNames | sed 's/[][",]//g' | tr ' ' '\n' | grep .

# Rebuild NixOS with fzf selection
rebuild *ARGS:
    #!/usr/bin/env bash
    echo "Selecting NixOS configuration..."
    host=$(just _get_hosts | fzf --prompt="Select NixOS configuration: ")
    if [ -n "$host" ]; then
        cmd="sudo nixos-rebuild switch --flake '.#$host' {{ARGS}}"
        echo "Executing: $cmd"
        eval "$cmd"
    else
        echo "No configuration selected, aborting."
        exit 1
    fi

# Switch home-manager configuration
hm *ARGS:
    #!/usr/bin/env bash
    echo "Selecting home-manager configuration..."
    combination=$(just _get_hm_combinations | fzf --prompt="Select home-manager configuration: ")
    if [ -n "$combination" ]; then
        cmd="home-manager switch --flake '.#$combination' -b backup {{ARGS}}"
        echo "Executing: $cmd"
        eval "$cmd"
    else
        echo "No configuration selected, aborting."
        exit 1
    fi

# Update flake and rebuild both nixos and home-manager
update: rebuild hm
    nix flake update

# Update yvim input and rebuild home-manager
update_yvim: hm
    nix flake lock --update-input yvim

# Print diagnostic information
diagnose:
    @echo "=== NixOS Configurations ==="
    @just _get_hosts
    @echo "\n=== Home Manager Configurations ==="
    @just _get_hm_combinations
