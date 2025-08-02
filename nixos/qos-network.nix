{ config, lib, pkgs, ... }:

{

  networking.hostName = config.quyo.host.name;

  networking.networkmanager.enable = true;

  # networking.wireless.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    allowSFTP = false;

    settings = {
      PermitRootLogin = "no";
      AllowUsers = [ "johm" ];

      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      ChallengeResponseAuthentication = false;

      MaxAuthTries = 3;
      MaxSessions = 5;
    };
  };

  services.tailscale.enable = config.quyo.tailscale.enable;

  services.postfix = {
    enable = true;
    hostname = config.quyo.host.fqdn;
    rootAlias = "johm@quyo.de";

    extraConfig = ''
      relayhost = [mx.quyo.net]:587
      smtp_tls_security_level = encrypt
      smtp_sasl_auth_enable = yes
      smtp_sasl_password_maps = ${config.quyo.postfix.sasl_password}
      smtp_sasl_security_options = noanonymous
    '';
  };

}
