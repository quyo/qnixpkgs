self: final: prev:

let
  version = final.lib.q.flake.version self;

  prettybat-slim = final.prettybat.override { withClangTools = false; };
in

{
  userprofile-unstable = final.buildEnv
    {
      name = "userprofile-global-unstable-${version}";
      paths = with final; [
        bat
        batdiff
        batgrep
        batman
        batpipe
        batwatch
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
        prettybat-slim
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
