{ config, lib, pkgs, ... }:

{

  # Does not remove garbage collector roots, such as old system configurations.
  # The following command deletes old roots, removing the ability to roll back to them: nix-collect-garbage --delete-older-than 7d
  nix.gc.automatic = true;
  nix.gc.dates = "02:15";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "johm" ];

  nixpkgs.config.allowUnfree = true;

  # Use the system nixpkgs for nix commands
  # https://www.zknotes.com/page/use%20the%20system%20nixpkgs%20for%20nix%20commands

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
     qnixpkgs.userprofile
  ];

}
