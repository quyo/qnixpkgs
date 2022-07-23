version: final: prev:

{

  userprofile = final.symlinkJoin
  {
    name = "userprofile-${version}";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with final; [
      cachixsh
      curl
      docker-compose
      dockersh
      dtach
      git
      hstr
      htop
      httpie
      iftop
      iotop
      joe
      jq
      mc
      nano
      nix-direnv
      nix-tree
      nixbuildsh
      nixsh
      screen
      tmux
      traceroute
      vim
      wget
      whois
    ];
  };

}
