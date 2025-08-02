{ config, lib, pkgs, ... }:

{

  # Define your hostname.
  networking.hostName = config.quyo.host.name;

  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
