self: final: prev:

let
  version = final.lib.q.flake.version self;

  prettybat-slim = final.prettybat.override { withClangTools = false; };

  # https://github.com/ibraheemdev/modern-unix
  modern-unix = with final; [
    # bat - A cat clone with syntax highlighting and Git integration.
    bat
    batdiff
    batgrep
    batman
    batpipe
    batwatch
    prettybat-slim
    # exa - A modern replacement for ls.
    exa
    # lsd - The next gen file listing command. Backwards compatible with ls.
    lsd
  ];
in

{
  userprofile-unstable = final.buildEnv
    {
      name = "userprofile-global-unstable-${version}";
      paths = with final; modern-unix ++ [
        bzip2
        coreutils-full
        croc
        curl
        diffutils
        dtach
        findutils
        gawk-with-extensions
        gdu
        git
        gnugrep
        gnumake
        gnused
        gnutar
        gzip
        hstr
        htop
        httpie
        iconv
        iftop
        iotop
        joe
        jq
        kakoune
        less
        mc
        moreutils
        nano
        nix
        nix-direnv
        nix-tree
        patch
        rename
        ripgrep
        screen
        shellscripts
        tmux
        traceroute
        tree
        unzip
        vim
        wget
        which
        whois
        xz
      ];
    };
}
