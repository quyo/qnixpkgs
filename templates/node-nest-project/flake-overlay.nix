system: self: final: prev:

let
  buildenv = file: name:
    let
      inherit (builtins) attrNames concatMap getAttr;
      inherit (final) buildEnv;
      inherit (final.lib) attrByPath getAttrFromPath importJSON splitString;

      json = importJSON file;

      getFlakePkgs = system: label:
        let
          outs = (getAttr label self).outputs;
          pkgs = (attrByPath [ "legacyPackages" system ] { } outs) // (attrByPath [ "packages" system ] { } outs);
        in
        map
          (x: getAttrFromPath (splitString "." x) pkgs)
          (getAttr label json);

      getAllPkgs = system: concatMap (getFlakePkgs system) (attrNames json);
    in
    buildEnv
      {
        inherit name;
        paths = getAllPkgs system;
      };

  prj-setup-dns-cert = final.writeShellApplication
    {
      name = "prj-setup-dns-cert";
      text = ''
        doctl --context quyo.zone compute domain records list --no-header --format Name,Type,ID "$PRJ_QUYO_DOMAIN" | grep -E "^$PRJ_QUYO_SUBDOMAIN +A+ " | awk -F' ' '{print $3}' | xargs --no-run-if-empty doctl --context quyo.zone compute domain records delete --force "$PRJ_QUYO_DOMAIN" && echo "[$PRJ_QUYO_SUBDOMAIN.$PRJ_QUYO_DOMAIN] Existing DNS records deleted." || echo "[$PRJ_QUYO_SUBDOMAIN.$PRJ_QUYO_DOMAIN] No existing DNS records found."

        doctl --context quyo.zone compute domain records create --record-type    A --record-name "$PRJ_QUYO_SUBDOMAIN" --record-data "$(flyctl ips list | grep '^v4' | awk -F' ' '{print $2}')" "$PRJ_QUYO_DOMAIN"
        doctl --context quyo.zone compute domain records create --record-type AAAA --record-name "$PRJ_QUYO_SUBDOMAIN" --record-data "$(flyctl ips list | grep '^v6' | awk -F' ' '{print $2}')" "$PRJ_QUYO_DOMAIN"

        sleep 15

        flyctl certs add "$PRJ_QUYO_SUBDOMAIN.$PRJ_QUYO_DOMAIN"
      '';
    };
in

{
  inherit prj-setup-dns-cert;

  devenv = buildenv ./flake-packages-devenv.json "devenv";
  runtime = buildenv ./flake-packages-runtime.json "runtime";
}
