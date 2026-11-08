# configuration.nix — minimal NixOS + i3 host ("work").
# Packages: i3, ungoogled-chromium, nixvim (same flake as ~/.dotfiles).
{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  editorPkg = inputs.nixvim.packages.${system}.default;
in
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "work";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.ly.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.configFile = ./i3/config;
  services.xserver.windowManager.i3.extraPackages = with pkgs; [
    dmenu
    i3status
    i3lock
  ];

  services.displayManager.defaultSession = "none+i3";

  users.users.loeclos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Same binary cache as ~/.dotfiles — pulls prebuilt SF fonts etc.
    substituters = [ "https://loeclos.cachix.org" ];
    trusted-public-keys = [
      "loeclos.cachix.org-1:ubZ/sF5yMoLs/MD80ACyL1jMHWNj/ctfFSYDLAVaClo="
    ];
    trusted-users = [
      "root"
      "loeclos"
    ];
  };

  environment.systemPackages = with pkgs; [
    editorPkg
    ungoogled-chromium
    alacritty
    git
    networkmanagerapplet
    xss-lock
    dex
    pulseaudio
  ];

  # Same SF fonts as ~/.dotfiles: custom SF Pro Display nerd build
  # (packages/sf-pro-nerd.nix) + sf-mono-nerd from apple-fonts.
  fonts = {
    packages = with pkgs; [
      sf-pro-nerd
      sf-mono-nerd
    ];

    fontconfig.defaultFonts = {
      monospace = [ "SFMono Nerd Font" ];
      sansSerif = [ "SFProDisplay Nerd Font" ];
    };
  };

  system.stateVersion = "25.11";
}
