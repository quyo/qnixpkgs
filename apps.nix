{ axonsh
, cronic
, duply
, duply-cronic
, kakoune
, linac
}:

let
  apps = {
    axonsh = { type = "app"; program = "${axonsh}/bin/axon.sh"; };
    cronic = { type = "app"; program = "${cronic}/bin/cronic"; };
    duply = { type = "app"; program = "${duply}/bin/duply"; };
    duply-cronic = { type = "app"; program = "${duply-cronic}/bin/duply-cronic"; };
    kakoune = { type = "app"; program = "${kakoune}/bin/kak"; };
    linac = { type = "app"; program = "${linac}/bin/linac"; };
  };
in

apps

# //
# {
#   default = apps.[...];
# }
