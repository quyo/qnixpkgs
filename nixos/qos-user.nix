{ config, lib, pkgs, ... }:

{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.johm = {
    isNormalUser = true;
    description = "Markus John";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkccByEYMQ2vXmSkU9x0WJpnLDseu8wFSKiPQCjH/Kt johm@Predator"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJbNZ7WPukcyJs8KSPn8/LGfk4knwicscIBIhKAuEh6 johnm@DE-ADN-2TYD893"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

}
