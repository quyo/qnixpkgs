{ config, lib, pkgs, ... }:

{

  options.quyo = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config.quyo = {
    desktop = true;
    hostname = "nyx";
    fqdn = "nyx.sky.ka.quyo.net";
    postfix.sasl_password = "...";
  };

}
