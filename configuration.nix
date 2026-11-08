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
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  # git identity + defaults, same as ~/.dotfiles (system-wide /etc/gitconfig).
  environment.etc."gitconfig".text = ''
    [user]
      name = gleb
      email = 116607327+loeclos@users.noreply.github.com
    [init]
      defaultBranch = main
    [credential]
      helper = !gh auth git-credential
  '';

  # Shell helpers, same as ~/.dotfiles.
  environment.shellAliases = {
    edit = "sudo -e";
    shell = "nix-shell";
    dots = "cd ~/Projects/workdots";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
      rbld() { sudo nixos-rebuild switch --flake "$HOME/Projects/workdots#work"; }
      update() { nix flake update --flake "$HOME/Projects/workdots"; }
    '';

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [ "HIST_IGNORE_ALL_DUPS" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    editorPkg
    ungoogled-chromium
    alacritty
    git
    gh
    unzip
    networkmanagerapplet
    xss-lock
    dex
    pulseaudio
  ];

  fonts.packages = with pkgs; [ dejavu_fonts ];

  system.stateVersion = "25.11";
}
