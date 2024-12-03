# Common build options stored in a simpler format
_BUILD_OPTIONS := "Debug Options\t--show-trace\tShow trace of evaluation\n\
Debug Options\t--debug\tEnable debug output\n\
Debug Options\t--verbose\tVerbose output\n\
Debug Options\t--keep-failed\tKeep failed builds\n\
Debug Options\t--keep-going\tContinue building despite errors\n\
Performance\t--cores 0\tUse all CPU cores\n\
Performance\t--max-jobs auto\tAutomatic job scaling\n\
Performance\t--builders ''\tDon't use remote builders\n\
Other\t--refresh\tConsider all files modified\n\
Other\t--recreate-lock-file\tRecreate lock file from scratch\n\
Other\t--no-write-lock-file\tDon't write hash/version locks\n\
Other\t--no-update-lock-file\tDon't update lock file"

# Helper recipe to get nixos configurations using jq
_get_hosts:
    #!/usr/bin/env bash
    nix flake show --json | jq -r '.nixosConfigurations | keys[]' 2>/dev/null || echo "anchor"

# Helper recipe to get home-manager configurations
_get_hm_combinations:
    #!/usr/bin/env bash
    nix eval .#homeConfigurations --apply __attrNames | sed 's/[][",]//g' | tr ' ' '\n' | grep .

# Helper to get build options using fzf
_get_build_options:
    #!/usr/bin/env bash
    echo -e "{{_BUILD_OPTIONS}}" | \
    fzf --multi \
        --delimiter='\t' \
        --with-nth=1,2,3 \
        --preview='echo -e "Category: {1}\nFlag: {2}\nDescription: {3}"' \
        --preview-window='bottom:3:wrap' \
        --header='Space to select multiple options, Enter to confirm' \
        --prompt="Select build options: " | \
    cut -f2 | \
    tr '\n' ' ' || echo ""

# Define the default recipe to list available commands
default:
    @just --list

# Show available options without executing
show-options:
    @echo "Build options available:"
    @echo -e "{{_BUILD_OPTIONS}}" | awk -F'\t' '{ printf "\n%s:\n  %s: %s\n", $1, $2, $3 }' | awk '!seen[$0]++'

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

# Rebuild NixOS with interactive build options selection
rebuild-with-options *ARGS:
    #!/usr/bin/env bash
    echo "Selecting NixOS configuration..."
    host=$(just _get_hosts | fzf --prompt="Select NixOS configuration: ")
    if [ -n "$host" ]; then
        echo "Selecting build options..."
        extra_opts=$(just _get_build_options)
        if [ -n "$extra_opts" ]; then
            echo "Selected build options: $extra_opts"
        else
            echo "No build options selected, proceeding with defaults"
            extra_opts=""
        fi
        cmd="sudo nixos-rebuild switch --flake '.#$host' $extra_opts {{ARGS}}"
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

# Switch home-manager configuration with interactive build options
hm-with-options *ARGS:
    #!/usr/bin/env bash
    echo "Selecting home-manager configuration..."
    combination=$(just _get_hm_combinations | fzf --prompt="Select home-manager configuration: ")
    if [ -n "$combination" ]; then
        echo "Selecting build options..."
        extra_opts=$(just _get_build_options)
        if [ -n "$extra_opts" ]; then
            echo "Selected build options: $extra_opts"
        else
            echo "No build options selected, proceeding with defaults"
            extra_opts=""
        fi
        cmd="home-manager switch --flake '.#$combination' -b backup $extra_opts {{ARGS}}"
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
    @echo "\n=== Build Options ==="
    @just show-options
