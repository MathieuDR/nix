# Define the default recipe to list available commands
default:
    @just --list

# Helper recipe to get NixOS hosts
_get_hosts:
    #!/usr/bin/env bash
    nix flake show --json | jq -r '.nixosConfigurations | keys[]' 2>/dev/null || echo "anchor"

# Helper recipe to get Darwin hosts
_get_darwin_hosts:
    #!/usr/bin/env bash
    nix flake show --json | jq -r '.darwinConfigurations | keys[]' 2>/dev/null || echo ""

# Helper recipe to get home-manager configurations
_get_hm_combinations:
    #!/usr/bin/env bash
    nix eval .#homeConfigurations --apply __attrNames | sed 's/[][",]//g' | tr ' ' '\n' | grep .

# Helper recipe to detect current platform
_get_platform:
    #!/usr/bin/env bash
    if [ "$(uname)" = "Darwin" ]; then
        echo "darwin"
    else
        echo "nixos"
    fi

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

# Rebuild Darwin system with fzf selection and hostname preselection
darwin *ARGS:
    #!/usr/bin/env bash
    echo "Selecting Darwin configuration..."
    host=$(just _get_darwin_hosts | fzf --prompt="Select Darwin configuration: " --query="$HOSTNAME" --select-1)
    if [ -n "$host" ]; then
        cmd="darwin-rebuild switch --flake '.#$host' {{ARGS}}"
        echo "Executing: $cmd"
        eval "$cmd"
    else
        echo "No configuration selected, aborting."
        exit 1
    fi

# Smart rebuild - detects platform and rebuilds accordingly
smart-rebuild *ARGS:
    #!/usr/bin/env bash
    platform=$(just _get_platform)
    if [ "$platform" = "darwin" ]; then
        just darwin {{ARGS}}
    else
        just rebuild {{ARGS}}
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

# Full rebuild - rebuilds both system (Darwin/NixOS) and home-manager
full-rebuild *ARGS:
    #!/usr/bin/env bash
    echo "=== Full Rebuild: System + Home Manager ==="
    just smart-rebuild {{ARGS}}
    echo "=== Now rebuilding home-manager ==="
    just hm {{ARGS}}

# Generate and copy public keys with updated naming convention to `cp`
generate-keys cp="":
    #!/usr/bin/env bash
    set -euo pipefail
    
    platform=$(just _get_platform)
    if [ "$platform" = "darwin" ]; then
        HOST=$(just _get_darwin_hosts | fzf --prompt="Select Darwin host: " --query="$HOSTNAME" --select-1) || HOST=$HOSTNAME
        key_dir="/etc/nix"
    else
        HOST=$(just _get_hosts | fzf --prompt="Select NixOS host: " --query="$HOSTNAME" --select-1) || HOST=$HOSTNAME
        key_dir="/etc/${HOST}"
    fi
    
    if [ "$platform" = "darwin" ]; then
        sudo mkdir -p "$key_dir"
        mkdir -p ~/.config/agenix
        
        sudo ssh-keygen -t ed25519 -C "agenix-${HOST}" -f "${key_dir}/agenix_${HOST}_system" -N ""
        ssh-keygen -t ed25519 -C "agenix-${USER}@${HOST}" -f ~/.config/agenix/agenix-key -N ""
    else
        sudo mkdir -p "$key_dir"
        mkdir -p ~/.config/agenix
        
        sudo ssh-keygen -t ed25519 -C "agenix-${HOST}" -f "${key_dir}/agenix_${HOST}_system" -N ""
        ssh-keygen -t ed25519 -C "agenix-${USER}@${HOST}" -f ~/.config/agenix/agenix-key -N ""
    fi
    
    # Handle copying with new naming convention
    if [ -n "{{cp}}" ]; then
        mkdir -p "{{cp}}"
        
        if [ "$platform" = "darwin" ]; then
            sudo cp "${key_dir}/agenix_${HOST}_system.pub" "{{cp}}/agenix-${HOST}-system.pub"
        else
            sudo cp "${key_dir}/agenix_${HOST}_system.pub" "{{cp}}/agenix-${HOST}-system.pub"
        fi
        cp ~/.config/agenix/agenix-key.pub "{{cp}}/agenix-${HOST}-${USER}.pub"
        
        echo "Public keys copied to {{cp}}"
    fi
    
    echo "SSH keys generated and copied successfully for host: $HOST (platform: $platform)"

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
    @echo "=== Platform ==="
    @just _get_platform
    @echo "\n=== NixOS Configurations ==="
    @just _get_hosts
    @echo "\n=== Darwin Configurations ==="  
    @just _get_darwin_hosts
    @echo "\n=== Home Manager Configurations ==="
    @just _get_hm_combinations
