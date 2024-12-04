# Define the default recipe to list available commands
default:
    @just --list

_get_hosts:
    #!/usr/bin/env bash
    nix flake show --json | jq -r '.nixosConfigurations | keys[]' 2>/dev/null || echo "anchor"

# Helper recipe to get home-manager configurations
_get_hm_combinations:
    #!/usr/bin/env bash
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

generate-keys cp="":
    #!/usr/bin/env bash
    set -euo pipefail
    
    HOST=$(just *get*hosts | fzf --prompt="Select host: ") || HOST=$(hostname)
    
    # Create directories
    mkdir -p "/etc/${HOST}" ~/.config/agenix
    
    # Generate system key
    sudo ssh-keygen -t ed25519 -C "agenix-${HOST}" -f "/etc/${HOST}/agenix_${HOST}_system" -N ""
    
    # Generate user key
    ssh-keygen -t ed25519 -C "agenix-${USER}@${HOST}" -f ~/.config/agenix/agenix-key -N ""
    
    # Handle copy if specified
    if [ "{{cp}}" = "cp" ]; then
        sudo mkdir -p "/etc/${HOST}"
        sudo cp "/etc/${HOST}/agenix_${HOST}_system.pub" "/etc/${HOST}/"
        mkdir -p ~/.config/agenix
        cp ~/.config/agenix/agenix-key.pub ~/.config/agenix/
    fi
    
    echo "SSH keys generated successfully for host: $HOST"

# Update flake and rebuild both nixos and home-manager
update:
    nix flake update

# Update yvim input and rebuild home-manager
update_yvim: 
    nix flake lock --update-input yvim

# Print diagnostic information
diagnose:
    @echo "=== NixOS Configurations ==="
    @just _get_hosts
    @echo "\n=== Home Manager Configurations ==="
    @just _get_hm_combinations
