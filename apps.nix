{
# axonsh,
  duply,
# linac
}:

let

  apps = {
#   axonsh = { type = "app"; program = "${axonsh}/bin/axon.sh"; };
    duply = { type = "app"; program = "${duply}/bin/duply"; };
#   linac = { type = "app"; program = "${linac}/bin/linac"; };
  };

in

apps

# //
# {
#   default = apps.[...];
# }
