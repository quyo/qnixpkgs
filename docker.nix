{ bashInteractive
, dockerTools
, qshell-minimal
}:

let
  contents = [
    qshell-minimal
  ];
in

dockerTools.buildLayeredImage {
  name = "quyo/qnixpkgs";
  tag = "latest";

  inherit contents;

  config = {
    Cmd = [ "${bashInteractive}/bin/bash" ];
  };
}
