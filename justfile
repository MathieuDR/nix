# Define the default recipe to list available commands
default:
    @just --list

# Rebuild NixOS configuration
rebuild host:
    #!/usr/bin/env bash
    case "{{host}}" in
        bastion)
            cmd="sudo nixos-rebuild switch --flake '.#bastion'"
            ;;
        anchor)
            cmd="sudo nixos-rebuild switch --flake '.#anchor'"
            ;;
        *)
            echo "Error: Unknown host '{{host}}'. Valid options: bastion, anchor"
            exit 1
            ;;
    esac
    echo "Executing: $cmd"
    eval "$cmd"

# Switch home-manager configuration
hm host:
    #!/usr/bin/env bash
    case "{{host}}" in
        bastion)
            config="thieu@bastion"
            ;;
        anchor)
            config="thieu@anchor"
            ;;
        imposter)
            config="thieu@7mind-JJ9C5X225D"
            ;;
        *)
            echo "Error: Unknown host '{{host}}'. Valid options: bastion, anchor, imposter"
            exit 1
            ;;
    esac
    cmd="home-manager switch --flake '.#$config' -b backup"
    echo "Executing: $cmd"
    eval "$cmd"

# Rebuild Darwin system
darwin:
    sudo darwin-rebuild switch --flake '.#7mind-JJ9C5X225D'

# Update flake inputs
update target="all":
    #!/usr/bin/env bash
    case "{{target}}" in
        all)
            nix flake update
            ;;
        yvim)
            nix flake lock --update-input yvim
            ;;
        exporter|highlight-exporter)
            nix flake lock --update-input highlight-exporter
            ;;
        *)
            echo "Error: Unknown target '{{target}}'. Valid options: all, yvim, exporter"
            exit 1
            ;;
    esac

# Generate and copy SSH keys for agenix
generate-keys user host target:
    #!/usr/bin/env bash
    set -euo pipefail
    
    USER="{{user}}"
    HOST="{{host}}"
    TARGET="{{target}}"
    
    key_dir="/etc/${HOST}"
    
    # Create directories
    sudo mkdir -p "$key_dir"
    mkdir -p ~/.config/agenix
    
    # Generate system key
    sudo ssh-keygen -t ed25519 -C "agenix-${HOST}" -f "${key_dir}/agenix_${HOST}_system" -N ""
    
    # Generate user key
    ssh-keygen -t ed25519 -C "agenix-${USER}@${HOST}" -f ~/.config/agenix/agenix-key -N ""
    
    # Copy keys to target directory
    mkdir -p "$TARGET"
    
    # Copy system keys (both public and private)
    sudo cp "${key_dir}/agenix_${HOST}_system" "$TARGET/agenix-${HOST}-system"
    sudo cp "${key_dir}/agenix_${HOST}_system.pub" "$TARGET/agenix-${HOST}-system.pub"
    sudo chmod 644 "$TARGET/agenix-${HOST}-system"
    
    # Copy user keys (both public and private)
    cp ~/.config/agenix/agenix-key "$TARGET/agenix-${HOST}-${USER}"
    cp ~/.config/agenix/agenix-key.pub "$TARGET/agenix-${HOST}-${USER}.pub"
    
    echo "SSH keys generated and copied to $TARGET"
    echo "System key: agenix-${HOST}-system"
    echo "User key: agenix-${HOST}-${USER}"
