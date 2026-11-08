> This repo is fully AI generated. Nothing is guaranteed to work. Use common sense. The owner uses this for personal purposes, and doesn't care about the quality of the code.

# workdots — minimal NixOS + i3

Very minimal NixOS flake: i3, ungoogled-chromium, and the same nixvim flake
as `~/.dotfiles` (`github:loeclos/nixvim`).

## Layout

- `flake.nix` — `nixosConfigurations.work`, inputs `nixpkgs` + `nixvim`
  (+ `pinned-nixpkgs`/`apple-fonts`/`sf-pro-dmg` for SF fonts, same as `~/.dotfiles`)
- `configuration.nix` — minimal host config, ly login, i3 via `configFile = ./i3/config`,
  `loeclos.cachix.org` substituter, SF fontconfig defaults
- `packages/sf-pro-nerd.nix` — SF Pro Display nerd build, copied from `~/.dotfiles`
- `hardware-configuration.nix` — placeholder; regenerate on the target machine
- `i3/config` — stock i3 default, except `$mod Mod4` and vim `hjkl` motions

## i3 deviations from stock

- `set $mod Mod4` (stock: `Mod1`)
- `set $left h / $down j / $up k / $right l` (stock: `j/k/l/semicolon`)
- `bindsym $mod+b split h` (stock: `$mod+h`; `$mod+h` is focus-left now)

## Use

```bash
cd ~/Projects/workdots
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
sudo nixos-rebuild switch --flake .#work
```
