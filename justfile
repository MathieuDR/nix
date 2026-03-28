# Define the default recipe to list available commands
default:
    @just --list

# Rebuild NixOS configuration
rebuild:
    sudo nixos-rebuild switch --flake '.#bastion'

# Switch home-manager configuration
hm:
    home-manager switch --flake '.#thieu@bastion' -b backup

# Dry-run builds (fast eval check, no switching)
dry-run:
    nixos-rebuild dry-build --flake '.#bastion'
    home-manager build --flake '.#thieu@bastion'

# Run flake checks (pre-commit hooks, etc.)
check:
    nix flake check

# Update flake inputs — optionally target a specific input
# Targets: all (default), nvim, fleeter, exporter
update target="all":
    #!/usr/bin/env bash
    case "{{target}}" in
        all)
            nix flake update
            ;;
        fleeter|fleet)
            nix flake update fleeter
            ;;
        exporter|highlight-exporter)
            nix flake update highlight-exporter
            ;;
        nvim|nixvim)
            nix flake update nixvim lexical
            ;;
        *)
            echo "Error: Unknown target '{{target}}'. Valid options: all, nvim, exporter, fleeter"
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

    sudo cp "${key_dir}/agenix_${HOST}_system" "$TARGET/agenix-${HOST}-system"
    sudo cp "${key_dir}/agenix_${HOST}_system.pub" "$TARGET/agenix-${HOST}-system.pub"
    sudo chmod 644 "$TARGET/agenix-${HOST}-system"

    cp ~/.config/agenix/agenix-key "$TARGET/agenix-${HOST}-${USER}"
    cp ~/.config/agenix/agenix-key.pub "$TARGET/agenix-${HOST}-${USER}.pub"

    echo "SSH keys generated and copied to $TARGET"
    echo "System key: agenix-${HOST}-system"
    echo "User key: agenix-${HOST}-${USER}"
