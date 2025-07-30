{ config, lib, pkgs, ... }:

{
  nix.settings.extra-substituters = [
    "https://nix-community.cachix.org"
    "https://quyo-public.cachix.org"
    "ssh://eu.nixbuild.net?priority=90"
  ];

  nix.settings.extra-trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "quyo-public.cachix.org-1:W83ifK7/6EvKU4Q2ZxvHRAkiIRzPeXYnp9LWHezs5U0="
    "nixbuild.net/quyo-1:TaAsUc6SBQnXhUQJM4s+1oQlTKa1e3M0u3Zqb36fbRc="
  ];

  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
    require-sigs = true;
    sandbox = "relaxed";
    trusted-users = [ "root" "johm" ];
  };

  nixpkgs.config.allowUnfree = true;

  # Does not remove garbage collector roots, such as old system configurations.
  # The following command deletes old roots, removing the ability to roll back to them: nix-collect-garbage --delete-older-than 7d
  nix.gc.automatic = true;
  nix.gc.dates = "02:15";

  # Use the system nixpkgs for nix commands
  # https://www.zknotes.com/page/use%20the%20system%20nixpkgs%20for%20nix%20commands

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
     qnixpkgs.userprofile
  ];

}
