# Architecture: Dendritic Pattern

Reference for conventions and decisions in this config.
For the pattern itself: [NixOS Discourse](https://discourse.nixos.org/t/the-dendritic-pattern/61271) · [mightyiam/dendritic](https://github.com/mightyiam/dendritic) · [NixCon 2025](https://talks.nixcon.org/nixcon-2025/talk/REJ3LF/)

---

## The idea

Every file under `modules/` is a [flake-parts](https://flake.parts) module, auto-discovered by [import-tree](https://github.com/vic/import-tree). Each file owns exactly one concern and declares what it contributes — a NixOS aspect, a Home Manager aspect, a package, or a combination. `flake.nix` stays minimal: just inputs and `import-tree ./modules`.

No manual `imports = [...]` lists. No central registry of modules.

---

## Conventions

### `_` prefix = excluded from auto-import
Directories or files prefixed with `_` are invisible to import-tree:
- `modules/home/nvim/_config/` — nixvim module config (not a flake-parts module itself)
- `modules/home/scripts/_git.nix` — helper, not a top-level aspect

### Directory modules
A directory with a `default.nix` is treated as a single module. Subdirectories are siblings, not children, unless prefixed with `_`.
- `modules/home/nvim/default.nix` — the nvim aspect, owns both build (`perSystem`) and install (`flake.modules.homeManager.nvim`)

### `pkgs/` vs `modules/`
- **`pkgs/`** — pure derivations: `{ pkgs }: derivation`. No module system, no options, no HM/NixOS integration.
- **`modules/`** — participates in the module system: declares options, configures HM or NixOS, may also build packages.

The rule: if it touches `programs.*`, `services.*`, `home.*`, or `flake.modules.*`, it belongs in `modules/`.

### `data/`
Static assets that are never rebuilt by Nix: wallpapers, snippets, agenix secrets, Firefox config backups. Referencing them from modules is fine; they just aren't derivations.

---

## Decisions

### Standalone Home Manager
`homeConfigurations` is declared separately from `nixosConfigurations`, not via the NixOS HM module. Tradeoffs accepted:
- ✅ `just hm` — switch HM without sudo or rebuilding the system
- ✅ Independent rollback (`home-manager generations`)
- ✅ Faster iteration on dotfiles
- ✅ Portable — same HM config could target a non-NixOS host
- ⚠️ Two commands to switch everything (`just rebuild && just hm`)
- ⚠️ Some duplication (nixpkgs instance, overlays declared twice)

### osConfig forwarding
`hosts/bastion/default.nix` passes `inputs.self.nixosConfigurations.bastion.config` as `osConfig` in HM's `extraSpecialArgs`. This lets HM modules react to NixOS-level options without coupling via the NixOS HM module.

No circular dependency: `nixosConfigurations` never references `homeConfigurations`.

Applied to: `hyprland`, `espanso`, `gaming`. Pattern:
```nix
flake.modules.homeManager.foo = { lib, osConfig, ... }:
  lib.mkIf osConfig.<sentinel>.enable { ... };
```

Adding a feature on a new host is one line in `hosts/<name>/default.nix` — add it to the NixOS modules list; the HM side activates automatically.

### Reactive shell integrations
Shell integrations (`enableFishIntegration`, `enableBashIntegration`) use `config.programs.fish.enable` / `config.programs.bash.enable` as the source of truth instead of hardcoded `true`. Avoids configuring integrations for shells that aren't present on a given host.

Intentional `false` values are kept with comments where they'd otherwise be reactive (e.g. eza bash aliases conflict with existing `ls` habits, zoxide bash is intentionally off).

### `finalPackage` pattern
HM programs like `programs.rofi` and `programs.zen-browser` produce a `finalPackage` that includes plugins and overrides baked in. Always reference `config.programs.<name>.finalPackage` rather than the raw `pkgs.<name>` when passing the package to other config (Hyprland `exec`, systemd services, etc.).

### nixvim not following nixpkgs
`nixvim` does not follow the main `nixpkgs` input. Reason: nixvim pins its own nixpkgs for stability, and forcing it to follow main nixpkgs caused `zls` build failures (Zig 0.14's build system tries to write to `/p` as a global cache — fails in the Nix sandbox). `lexical` follows `nixvim/nixpkgs` for ABI consistency with the Erlang/Elixir toolchain.

`zls` is disabled with a comment in `_config/lsp.nix` until nixpkgs resolves the sandbox issue.

### nvim as a module, not a package
`modules/home/nvim/` is under `modules/home/` because it uses the nixvim module system and configures Home Manager (`home.packages`). It also owns its `perSystem` build in the same file — a single module can contribute to multiple flake outputs.

---

## Adding a new aspect

1. Create `modules/nixos/<name>.nix` and/or `modules/home/<subdir>/<name>.nix`
2. Declare `flake.modules.nixos.<name>` or `flake.modules.homeManager.<name>` inside
3. Add the name to the appropriate list in `hosts/<hostname>/default.nix`
4. If the HM aspect should be conditional on NixOS state, add `osConfig` to the module args and wrap with `lib.mkIf`

import-tree picks up the file automatically — no registration needed anywhere else.
