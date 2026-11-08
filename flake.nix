{
  description = "workdots — minimal NixOS + i3 + nixvim + ungoogled-chromium";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pinned-nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Same nixvim as ~/.dotfiles (github:loeclos/nixvim, nixpkgs follows).
    nixvim = {
      url = "github:loeclos/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # SF fonts, same as ~/.dotfiles: apple-fonts overlay (sf-mono-nerd)
    # + custom 7-font SF Pro Display nerd build from Apple's DMG.
    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "pinned-nixpkgs";
    };

    sf-pro-dmg = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      flake = false;
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations.work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          (
            { ... }:
            {
              nixpkgs.overlays = [
                inputs.apple-fonts.overlays.default
                (final: prev: {
                  sf-pro-nerd = prev.callPackage ./packages/sf-pro-nerd.nix {
                    src = inputs.sf-pro-dmg;
                  };
                })
              ];
            }
          )
        ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}
