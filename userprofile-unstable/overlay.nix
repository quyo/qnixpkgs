version: final: prev:

{

  userprofile-unstable = final.symlinkJoin
  {
    name = "userprofile-global-unstable-${version}";
    preferLocalBuild = false;
    allowSubstitutes = true;

    paths = with final; [
      bzip2
      coreutils
      croc
      curl
      diffutils
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
      patch
      screen
      shellscripts
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
