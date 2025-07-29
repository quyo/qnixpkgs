{
  description = "NixOS with qnixpkgs";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://quyo-public.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "quyo-public.cachix.org-1:W83ifK7/6EvKU4Q2ZxvHRAkiIRzPeXYnp9LWHezs5U0="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    qnixpkgs.url = "github:quyo/qnixpkgs";
    qnixpkgs.inputs.nixpkgs-stable.follows = "nixpkgs";
    qnixpkgs.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    qnixpkgs.inputs.qnixpkgs.follows = "qnixpkgs";
  };

  outputs = { self, nixpkgs, qnixpkgs, ... }@inputs:
    let
      hostname = "nyx";
      system = "x86_64-linux";

      overlay-qnixpkgs = final: prev: {
        qnixpkgs = qnixpkgs.packages.${prev.system};
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay-qnixpkgs ];
        config.allowUnfree = true;
      };
    in rec
    {
      packages.${system} = { userprofile = pkgs.qnixpkgs.userprofile; };

      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [

          # Overlays-module makes "pkgs.qnixpkgs-userprofile-*" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-qnixpkgs ]; })

          ./configuration.nix

          qnixpkgs.nixosModules.userprofile

        ];
      };
    };
}
