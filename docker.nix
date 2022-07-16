pkgs:

let

  contents = with pkgs; [
    qshell-minimal
  ];

in

pkgs.dockerTools.buildLayeredImage {
  name = "quyo/qnixpkgs";
  tag = "latest";

  inherit contents;

  config = {
    Cmd = [ "${pkgs.bashInteractive}/bin/bash" ];
  };
}
