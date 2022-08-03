self: final: prev:

let
  version = final.lib.q.flakeVersion self;
in

{
  userprofile-unstable = final.buildEnv
    {
      name = "userprofile-global-unstable-${version}";
      paths = with final; [
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
        vim
        wget
        which
        whois
        xz
      ];
    };
}
