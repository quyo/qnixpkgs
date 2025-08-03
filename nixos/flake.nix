{
  description = "NixOS with qnixpkgs";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://quyo-public.cachix.org"
      "ssh://eu.nixbuild.net?priority=90"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "quyo-public.cachix.org-1:W83ifK7/6EvKU4Q2ZxvHRAkiIRzPeXYnp9LWHezs5U0="
      "nixbuild.net/quyo-1:TaAsUc6SBQnXhUQJM4s+1oQlTKa1e3M0u3Zqb36fbRc="
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

  outputs = { self, nixpkgs, nixpkgs-unstable, qnixpkgs, ... }@inputs:
    let
      hostname = "nyx";
      system = "x86_64-linux";

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      overlay-qnixpkgs = final: prev: {
        qnixpkgs = qnixpkgs.packages.${prev.system};
      };
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [

          ({ config, pkgs, ... }: {

            nixpkgs.overlays = [ overlay-unstable overlay-qnixpkgs ];

            nix.registry.nixpkgs-unstable = {
              from = {
                id = "nixpkgs-unstable";
                type = "indirect";
              };
              to = {
                type = "github";
                owner = "NixOS";
                repo = "nixpkgs";
                rev = nixpkgs-unstable.rev;
              };
            };

            nix.registry.qnixpkgs = {
              from = {
                id = "qnixpkgs";
                type = "indirect";
              };
              to = {
                type = "github";
                owner = "quyo";
                repo = "qnixpkgs";
                rev = qnixpkgs.rev;
              };
            };

          })

          ./configuration.nix
          qnixpkgs.nixosModules.userprofile

        ];
      };
    };
}
