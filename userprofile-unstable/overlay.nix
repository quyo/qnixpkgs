version: final: prev:

{

  userprofile-unstable = final.buildEnv
  {
    name = "userprofile-global-unstable-${version}";
    paths = with final; [
      bzip2
      coreutils
      croc
      curl
      diffutils
      dtach
      findutils
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
      ripgrep
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
