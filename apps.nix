self: system:

let

  pkgs = self.packages.${system};

  apps = with pkgs; {
    duply = { type = "app"; program = "${pkgs.duply}/bin/duply"; };
  };

in

apps

# //
# {
#   default = apps.[...];
# }
