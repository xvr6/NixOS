# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Switch Commands

```bash
# Rebuild and switch (preferred - uses nh)
nh os switch --hostname nixwork

# Direct nixos-rebuild
sudo nixos-rebuild switch --flake ~/NixOS#nixwork

# List generations
list-gens

# Rollback to generation N
rollback N
```

`nh` is configured via `core/nh.nix` with flake path `~/NixOS` and auto-cleans generations older than 7 days (keeps 3).

## Architecture

This is a **flake-parts** config using **import-tree** to automatically discover all `.nix` files under `modules/` — no manual registration needed.

```
flake.nix → flake-parts → import-tree → modules/**/*.nix
```

### Directory Roles

- **`core/`** — Shared NixOS system modules imported by every host (shell, networking, services, packages, fonts, etc.). `core/default.nix` is the single import point.
- **`modules/hosts/<hostname>/`** — Per-machine definitions. Three files per host:
  - `hardware.nix` → exports `flake.nixosModules.<hostname>Hardware`
  - `configuration.nix` → exports `flake.nixosModules.<hostname>Config` (imports core + hardware + features)
  - `default.nix` → exports `flake.nixosConfigurations.<hostname>` (wires config into a nixosSystem)
- **`modules/features/`** — Per-system packages and app configs using `perSystem` (flake-parts abstraction). Apps are wrapped declaratively via `wrapper-modules`.
- **`archive/`** — Old Hyprland-based configs, kept for reference only.

### Adding a New Host

Copy `modules/hosts/nixwork/` to `modules/hosts/<newhostname>/`, update `variables.nix` and `hardware.nix`, and the host is automatically discovered.

### Module Patterns

**Core modules** (`core/`) are plain NixOS modules. They reference host variables via:
```nix
{ host, pkgs, ... }:
let inherit (import ../../modules/hosts/${host}/variables.nix) timezone locale; in { ... }
```

**Feature modules** (`modules/features/`) use flake-parts `perSystem`:
```nix
{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myApp = inputs.wrapper-modules.wrappers.kitty.wrap { ... };
  };
}
```

**Host modules** (`modules/hosts/`) export flake outputs:
```nix
{ self, inputs, ... }: {
  flake.nixosModules.nixworkConfig = { pkgs, lib, ... }: {
    imports = [ ../../../core self.nixosModules.nixworkHardware ... ];
  };
}
```

## Key Inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | nixos-26.05 |
| `nixos-hardware` | Framework AMD AI 300-series profile |
| `flake-parts` | Module system |
| `import-tree` | Auto-discovers modules under `modules/` |
| `wrapper-modules` | Declarative per-app config wrapping |
| `nixvim` | Separate Neovim config flake (xvr6/nixvim) |

## Current Host: nixwork

Framework laptop (AMD Ryzen AI 300-series), zen kernel, Niri Wayland compositor, Zsh primary shell, Catppuccin Macchiato theme throughout.

User `xvr6` is in groups: wheel, input, audio, video, docker, libvirtd, kvm.
