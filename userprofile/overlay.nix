version: final: prev:

{

  userprofile = final.symlinkJoin
  {
    name = "userprofile-${version}";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with final; [
      cachixsh
      coreutils
      curl
      docker-compose
      dockersh
      dtach
      findutils
      gawk
      gawk-with-extensions
      git
      gnugrep
      gnused
      gnutar
      gzip
      hstr
      htop
      httpie
      iftop
      iotop
      joe
      jq
      less
      mc
      moreutils
      nano
      nix
      nix-direnv
      nix-tree
      nixbuildsh
      nixsh
      screen
      tmux
      traceroute
      vim
      wget
      which
      whois
    ];
  };

}
