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
    # ripgrep-all
    # ag / silver-searcher - A code searching tool similar to ack, but faster.
    silver-searcher
    # fzf - A general purpose command-line fuzzy finder.
    fzf
    # mcfly - Fly through your shell history. Great Scott!
    mcfly
    # choose - A human-friendly and fast alternative to cut and (sometimes) awk
    choose
    # jq - sed for JSON data.
    jq
    # sd - An intuitive find & replace CLI (sed alternative).
    sd
    # cheat - Create and view interactive cheatsheets on the command-line.
    cheat
    # tldr - A community effort to simplify man pages with practical examples.
    tldr
    # bottom - Yet another cross-platform graphical process/system monitor.
    bottom
    # glances - Glances an Eye on your system. A top/htop alternative for GNU/Linux, BSD, Mac OS and Windows operating systems.
    glances
    # gtop - System monitoring dashboard for terminal.
    gtop
    # hyperfine - A command-line benchmarking tool.
    hyperfine
    # gping - ping, but with a graph.
    gping
    # procs - A modern replacement for ps written in Rust.
    procs
    # httpie - A modern, user-friendly command-line HTTP client for the API era.
    httpie
    # curlie - The power of curl, the ease of use of httpie.
    curlie
    # xh - A friendly and fast tool for sending HTTP requests. It reimplements as much as possible of HTTPie's excellent design, with a focus on improved performance.
    xh
    # zoxide - A smarter cd command inspired by z.
    zoxide
    # dog - A user-friendly command-line DNS client. dig on steroids
    dogdns
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
            direnv
            # dog
            dotfiles
            dtach
            findutils
            fzf-git
            gawk-with-extensions
            gdu
            git
            gnugrep
            gnumake
            gnused
            gnutar
            gzip
            htop
            iconv
            iftop
            iotop
            joe
            kakoune
            less
            mc
            mkcert
            moreutils
            nano
            nettools
            patch
            rdfind
            rename
            screen
            shellscripts
            testssl
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
            nix-direnv
            nix-tree
          ];
        };
    };
}
