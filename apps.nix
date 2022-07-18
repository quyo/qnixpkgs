{
  duply,
  linac
}:

let

  apps = {
    duply = { type = "app"; program = "${duply}/bin/duply"; };
    linac = { type = "app"; program = "${linac}/bin/linac"; };
  };

in

apps

# //
# {
#   default = apps.[...];
# }
