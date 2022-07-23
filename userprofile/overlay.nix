version: final: prev:

{

  userprofile = final.symlinkJoin
  {
    name = "userprofile-${version}";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with final; [
      bzip2
      cachixsh
      coreutils
      curl
      diffutils
      docker-compose
      dockersh
      dtach
      findutils
      gawk
      gawk-with-extensions
      git
      gnugrep
      gnumake
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
      patch
      screen
      tmux
      traceroute
      tree
      vim
      wget
      which
      whois
      xz
    ];
  };

}
