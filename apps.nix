{ duply }:

let

  apps = {
    duply = { type = "app"; program = "${duply}/bin/duply"; };
  };

in

apps

# //
# {
#   default = apps.[...];
# }
