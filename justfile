# Define the default recipe to list available commands
default:
    @just --list

# Helper recipe to get NixOS hosts
_get_hosts:
    #!/usr/bin/env bash
    nix flake show --json | jq -r '.nixosConfigurations | keys[]' 2>/dev/null || echo "anchor"

# Helper recipe to get home-manager configurations
_get_hm_combinations:
    #!/usr/bin/env bash
    nix eval .#homeConfigurations --apply __attrNames | sed 's/[][",]//g' | tr ' ' '\n' | grep .

# Rebuild NixOS with fzf selection and hostname preselection
rebuild *ARGS:
    #!/usr/bin/env bash
    echo "Selecting NixOS configuration..."
    host=$(just _get_hosts | fzf --prompt="Select NixOS configuration: " --query="$HOSTNAME" --select-1)
    if [ -n "$host" ]; then
        cmd="sudo nixos-rebuild switch --flake '.#$host' {{ARGS}}"
        echo "Executing: $cmd"
        eval "$cmd"
    else
        echo "No configuration selected, aborting."
        exit 1
    fi

# Switch home-manager configuration with username preselection
hm *ARGS:
    #!/usr/bin/env bash
    echo "Selecting home-manager configuration..."
    combination=$(just _get_hm_combinations | fzf --prompt="Select home-manager configuration: " --query="$USER@$HOSTNAME" --select-1)
    if [ -n "$combination" ]; then
        cmd="home-manager switch --flake '.#$combination' -b backup {{ARGS}}"
        echo "Executing: $cmd"
        eval "$cmd"
    else
        echo "No configuration selected, aborting."
        exit 1
    fi

# Generate and copy public keys with updated naming convention to `cp`
generate-keys cp="":
    #!/usr/bin/env bash
    set -euo pipefail
    
    HOST=$(just _get_hosts | fzf --prompt="Select host: " --query="$HOSTNAME" --select-1) || HOST=$HOSTNAME
    
    sudo mkdir -p "/etc/${HOST}"
    mkdir -p ~/.config/agenix
    
    sudo ssh-keygen -t ed25519 -C "agenix-${HOST}" -f "/etc/${HOST}/agenix_${HOST}_system" -N ""
    ssh-keygen -t ed25519 -C "agenix-${USER}@${HOST}" -f ~/.config/agenix/agenix-key -N ""
    
    # Handle copying with new naming convention
    if [ -n "{{cp}}" ]; then
        mkdir -p "{{cp}}"
        
        sudo cp "/etc/${HOST}/agenix_${HOST}_system.pub" "{{cp}}/agenix-${HOST}-system.pub"
        cp ~/.config/agenix/agenix-key.pub "{{cp}}/agenix-${HOST}-${USER}.pub"
        
        echo "Public keys copied to {{cp}}"
    fi
    
    echo "SSH keys generated and copied successfully for host: $HOST"

# Update flake and rebuild both nixos and home-manager
update:
    nix flake update

# Update yvim input and rebuild home-manager
update_yvim: 
    nix flake lock --update-input yvim

update_exporter: 
    nix flake lock --update-input highlight-exporter

# Print diagnostic information
diagnose:
    @echo "=== NixOS Configurations ==="
    @just _get_hosts
    @echo "\n=== Home Manager Configurations ==="
    @just _get_hm_combinations
