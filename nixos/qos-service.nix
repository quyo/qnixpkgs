{ config, lib, pkgs, ... }:

{

  virtualisation.docker.enable = true;

  systemd.timers.nixosupd = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
  systemd.services.nixosupd = {
    script = ''
      set -euo pipefail
      IFS=$'\n\t'

      PATH=$PATH:${pkgs.nix}/bin:${pkgs.nixos-rebuild}/bin:${pkgs.git}/bin

      nix flake update nixpkgs           --flake /etc/nixos
      nix flake update nixpkgs-unstable  --flake /etc/nixos
      nixos-rebuild switch               --flake /etc/nixos

      GIT_AUTHOR_NAME="NixOSupd service"  GIT_AUTHOR_EMAIL="nixosupd@${config.quyo.host.fqdn}" \
      GIT_COMMITTER_NAME=$GIT_AUTHOR_NAME GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL                \
      git -C /etc/nixos commit -a -m "v$(date +%Y-%m-%d)-00"

      nix-collect-garbage --delete-older-than 90d
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

}
