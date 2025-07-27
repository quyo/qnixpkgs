{ config, lib, pkgs, ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.johm = { pkgs, ... }: {
    home.packages = [ pkgs.qnixpkgs.userprofile ];

    programs.bash = {
      enable = true;
      bashrcExtra = ''
        source "/etc/profiles/per-user/johm/share/dotfiles/.bashrc"
      '';
      profileExtra = ''
        source "/etc/profiles/per-user/johm/share/dotfiles/.profile"
      '';
    };

    # This value determines the Home Manager release that your configuration is 
    # compatible with. This helps avoid breakage when a new Home Manager release 
    # introduces backwards incompatible changes. 
    #
    # You should not change this value, even if you update Home Manager. If you do 
    # want to update the value, then make sure to first check the Home Manager 
    # release notes. 
    home.stateVersion = "25.05"; # Please read the comment before changing. 
  };
}
