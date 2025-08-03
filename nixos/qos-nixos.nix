{ config, lib, pkgs, ... }:

{

  nix.settings = {
    auto-optimise-store = true;
    builders-use-substitutes = true;
    experimental-features = [ "nix-command" "flakes" ];
    require-sigs = true;
    sandbox = "relaxed";
    trusted-users = [ "johm" ];

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

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     qnixpkgs.userprofile
  ];

  # Use the system nixpkgs for nix commands
  # https://www.zknotes.com/page/use%20the%20system%20nixpkgs%20for%20nix%20commands


  # Does not remove garbage collector roots, such as old system configurations.
  #nix.gc.automatic = true;
  #nix.gc.dates = "02:15";

  systemd.timers.nixosupd = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  systemd.services.nixosupd = {
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      set -euo pipefail
      IFS=$'\n\t'

      PATH=$PATH:${pkgs.nix}/bin
      PATH=$PATH:${pkgs.nixos-rebuild}/bin
      PATH=$PATH:${pkgs.git}/bin
      PATH=$PATH:${pkgs.openssh}/bin

      nix-collect-garbage --delete-older-than 90d

      nix flake update nixpkgs           --flake /etc/nixos
      nix flake update nixpkgs-unstable  --flake /etc/nixos
      nixos-rebuild switch               --flake /etc/nixos

      GIT_AUTHOR_NAME="NixOSupd service"  GIT_AUTHOR_EMAIL="nixosupd@${config.quyo.host.fqdn}" \
      GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL                \
      git -C /etc/nixos commit -a -m "v$(date +%Y-%m-%d)-00"
    '';
  };

}
