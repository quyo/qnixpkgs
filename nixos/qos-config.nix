{ config, lib, pkgs, ... }:

{

  options.quyo = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.quyo = {
    desktop = true;
    host = rec {
      name = "nyx";
      fqdn = "${name}.sky.quyo.net";
    };
    tailscale.enable = true;
    postfix.sasl_password = "static:{user}:{pwd}";
  };

  config.networking = {
    useDHCP = false;

    interfaces.ens18 = {
      ipv4.addresses = [{
        address = "192.168.xx.xx";
        prefixLength = 23;
      }];
    };

    defaultGateway = "192.168.xx.xx";
    nameservers = [ "192.168.xx.xx" ];
  };

}
