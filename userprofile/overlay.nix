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
    # delta - A viewer for git and diff output.
    delta
    # dust - A more intuitive version of du written in rust.
    du-dust
    # duf - A better df alternative.
    duf
    # broot - A new way to see and navigate directory trees.
    broot
    # fd - A simple, fast and user-friendly alternative to find.
    fd
    # ripgrep - An extremely fast alternative to grep that respects your gitignore
    ripgrep
    # ag / silver-searcher - A code searching tool similar to ack, but faster.
    silver-searcher
    # fzf - A general purpose command-line fuzzy finder.
    fzf
  ];
in

{
  userprofile =
    {
      stable = final.buildEnv
        {
          name = "userprofile-global-stable-${version}";
          paths = with final; modern-unix ++ [
            bzip2
            coreutils-full
            croc
            curl
            diffutils
            dotfiles
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
            mkcert
            moreutils
            nano
            nettools
            nix-direnv
            nix-tree
            patch
            rename
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

      unstable = final.buildEnv
        {
          name = "userprofile-global-unstable-${version}";
          paths = with final; [
            nix
          ];
        };
    };
}
