{ config, lib, pkgs, ... }:

{

  virtualisation.docker.enable = true;


  systemd.timers."nixgc" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
  systemd.services."nixgc" = {
    script = ''
      ${pkgs.nix}/bin/nix-collect-garbage --delete-older-than 7d
    '';
    serviceConfig = {
      Type = "oneshot";
    };
  };

}
