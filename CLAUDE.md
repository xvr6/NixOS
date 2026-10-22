# NixOS flake

## Comments
- Keep comments short and to the point: one line where possible, two at most.
- Only explain the non-obvious (why, gotchas, cross-file links); don't restate the code.
- No banner/section-divider blocks or long tutorials. Usage guidance goes in a few terse lines at the top of the file.

## Layout
- Apps with more than one concern get a folder with `default.nix` importing split files (e.g. `home-modules/desktop/umbriel/`, `home-modules/programs/media/obsidian/`).
