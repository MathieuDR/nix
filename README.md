> [!WARNING]
> This repository has been archived and is no longer maintained.
> Development has moved to [codeberg.org/MathieuDR/nixdots](https://codeberg.org/MathieuDR/nixdots).

# ySomic's NixOS Configuration

NixOS + Home Manager configuration for the `bastion` machine, structured using the [dendritic pattern](#dendritic-pattern).

## 📁 Structure

```
.
├── flake.nix                    ← minimal: inputs + import-tree ./modules
├── justfile                     ← common operations (rebuild, hm, update, ...)
├── modules/
│   ├── devshell.nix             ← development shell (alejandra, just, agenix, ...)
│   ├── flake-modules.nix        ← declares flake.modules.{nixos,homeManager} options
│   ├── hosts.nix                ← thin registry → imports hosts/bastion/default.nix
│   ├── overlays.nix             ← flake.overlays (stoat-desktop, claude-desktop)
│   ├── pkgs.nix                 ← perSystem packages (highlight-exporter, fleeter, zeit, ...)
│   ├── nixos/                   ← NixOS aspects (each file = one concern)
│   │   ├── base.nix             ← bootloader, locale, nix settings, graphics
│   │   ├── networking.nix, user.nix, security.nix, sound.nix
│   │   ├── hyprland.nix, services.nix, cleanup.nix, maintenance.nix
│   │   ├── packages.nix, unfree.nix, gaming.nix
│   │   └── hardware-amd.nix, hardware-wine.nix, podman.nix
│   └── home/                    ← Home Manager aspects
│       ├── base.nix             ← bundles: custom, security, fonts, files, packages, scripts
│       ├── custom.nix           ← options.custom.{terminal,browser,fileManager,launcher}
│       ├── security.nix, fonts.nix, files.nix, packages.nix
│       ├── nvim/                ← neovim: perSystem build + HM install aspect
│       │   ├── default.nix
│       │   └── _config/        ← nixvim module config (excluded from auto-import)
│       ├── desktop/             ← hwdr bundle (Hyprland+Waybar+Dunst+Rofi) + hyprlock
│       ├── shell/               ← base tools, fish, kitty, navi
│       ├── theming/             ← catppuccin (gtk, qt, cursor, spicetify)
│       ├── apps/                ← zen, mpv, imv, copyq, espanso, signal, discord-fix, slicer
│       ├── gaming/              ← mangohud, protonup, wine/bottles
│       ├── tools/               ← ccalibration, stresstests
│       ├── services/            ← syncthing, healthchecks, transcriber
│       └── scripts/             ← custom shell scripts (git helpers, shlink)
├── hosts/
│   └── bastion/
│       ├── default.nix          ← assembles nixosConfigurations + homeConfigurations
│       ├── hardware-configuration.nix
│       ├── monitors.nix         ← dual monitor layout (DP-3 + DP-1 @ 165Hz)
│       ├── startup.nix          ← exec-once: discord, spotify, zen, kitty
│       └── misc.nix             ← custom.* values, host packages, stateVersion
├── pkgs/                        ← standalone derivations (no module system)
│   ├── castersoundboard.nix, dungeondraft.nix, zeit.nix
└── data/                        ← static assets (never rebuilt by Nix)
    ├── config/                  ← eza theme, firefox STG backup
    ├── wallpapers/
    ├── snippets/                ← neovim VSCode-format snippets
    └── secrets/                 ← agenix-encrypted secrets + public keys
```

## 🌿 Dendritic Pattern

This config uses the **dendritic pattern** — every file in `modules/` is a self-contained [flake-parts](https://flake.parts) module, automatically discovered via [import-tree](https://github.com/vic/import-tree). No manual `imports = [...]` lists to maintain.

Key rules:
- `flake.nix` stays minimal — just inputs and `import-tree ./modules`
- Each file declares what it owns (`flake.modules.nixos.*`, `flake.modules.homeManager.*`, `perSystem`, etc.)
- Files/directories prefixed with `_` are excluded from auto-import (e.g. `nvim/_config/`)
- Host assembly lives in `hosts/<name>/default.nix`, composed from aspects

**Learn more:**
- [docs/dendritic.md](docs/dendritic.md) — conventions and decisions in *this* config
- [The dendritic pattern — NixOS Discourse](https://discourse.nixos.org/t/the-dendritic-pattern/61271)
- [mightyiam/dendritic — pattern documentation](https://github.com/mightyiam/dendritic)
- [vic/import-tree](https://github.com/vic/import-tree)
- [flake-parts](https://flake.parts)
- [NixCon 2025 talk](https://talks.nixcon.org/nixcon-2025/talk/REJ3LF/)

## 🚀 Features

- **Hyprland** compositor with Waybar, Dunst, Rofi, Hyprlock (composed as the `hwdr` bundle)
- **Catppuccin Mocha** theme across GTK, QT, cursor, Kitty, Spicetify
- **Neovim** via nixvim — LSP (Elixir/lexical, Nix, TS, Go, Python, ...), Telescope, Treesitter
- **Development** — fish, direnv, git, fzf, zoxide, oh-my-posh, gh
- **Gaming** — Steam, Gamemode, Proton, MangoHud, Wine/Bottles
- **Swappable components** via `custom.*` options — terminal, browser, file manager, launcher
- **Secrets management** with [agenix](https://github.com/ryantm/agenix)
- **Custom scripts** — git diff helpers, shlink URL shortener, garden-share
- **Services** — Syncthing, voice transcription, health check monitoring

## 🛠 Usage

### Common operations

```bash
just              # list available commands
just rebuild      # sudo nixos-rebuild switch --flake '.#bastion'
just hm           # home-manager switch --flake '.#thieu@bastion'
just check        # nix flake check
just update       # update all flake inputs
just update nvim  # update only nixvim + lexical
just update fleeter
just update exporter
```

### Building without switching

```bash
nix build '.#nixosConfigurations.bastion.config.system.build.toplevel'
nix build '.#homeConfigurations."thieu@bastion".activationPackage'
nix run '.#nvim'
```

## ⚙️ Adding a New Host

1. Save `hardware-configuration.nix` to `hosts/<newhost>/`
2. Create `hosts/<newhost>/default.nix` — assemble aspects from `inputs.self.modules.nixos.*` and `inputs.self.modules.homeManager.*`
3. Add optional host-specific `monitors.nix`, `startup.nix`, `misc.nix`
4. Register in `modules/hosts.nix`: `imports = [ ../hosts/<newhost>/default.nix ];`

No helpers to update, no new directories required elsewhere.

## 🔐 Bootstrapping

1. Generate agenix keys:
   ```bash
   just generate-keys thieu bastion /path/to/output
   ```
2. Add the generated public keys to `data/secrets/secrets.nix`
3. Rekey all secrets: `agenix --rekey`
4. Enable SSH: copy `id_rsa.pub` into the secrets store
5. Syncthing — gather device ID: `syncthing generate`, add to `modules/home/services/syncthing.nix`
6. Firefox — import STG backup from `data/config/firefox/STG.json`

## 🤝 Credits

- [mightyiam](https://github.com/mightyiam) — creator of the dendritic pattern
- [vic](https://github.com/vic) — author of import-tree
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles/) — early inspiration
- [Catppuccin](https://github.com/catppuccin/nix) — theming
- [nix-community/nixvim](https://github.com/nix-community/nixvim)

## 🔍 Resources

- [NixOS Wiki](https://nixos.wiki/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland Documentation](https://wiki.hyprland.org/)
- [flake-parts](https://flake.parts)
- [Nixpkgs](https://github.com/NixOS/nixpkgs)
