self: final: prev:

let
  ansible = final.jupyterWith.kernels.ansibleKernel {
    name = "ansible";
  };

  bash = final.jupyterWith.kernels.bashKernel {
    name = "bash";
  };

  c = final.jupyterWith.kernels.cKernelWith {
    name = "c";
    packages = p: with p; [ ];
  };

  cpp = final.jupyterWith.kernels.xeusCling {
    name = "cpp";
  };

  go = final.jupyterWith.kernels.gophernotes {
    name = "go";
  };

  haskell = final.jupyterWith.kernels.iHaskellWith {
    name = "haskell";
    packages = p: with p; [ formatting ];
    # Optional definition of `haskellPackages` to be used.
    haskellPackages = final.haskellPackages;
  };

  javascript = final.jupyterWith.kernels.iJavascript {
    name = "javascript";
  };

  nix = final.jupyterWith.kernels.iNixKernel {
    name = "nix";
  };

  ocaml = final.jupyterWith.kernels.ocamlWith {
    name = "ocaml";
    packages = with final; [ ];
  };

  python = final.jupyterWith.kernels.iPythonWith {
    name = "python";
    packages = p: with p; [ numpy sympy pandas ];
    # Optional definition of `python3` to be used.
    python3 = final.python3;
    ignoreCollisions = true;
  };

  r = final.jupyterWith.kernels.iRWith {
    name = "r";
    packages = p: with p; [ ggplot2 ];
    # Optional definition of `rPackages` to be used.
    rPackages = final.rPackages;
  };

  ruby = final.jupyterWith.kernels.iRubyWith {
    name = "ruby";
    packages = p: with p; [ ];
  };

  rust = final.jupyterWith.kernels.rustWith {
    name = "rust";
    packages = with final; [ ];
  };
in

{
  jupyterlabEnvironment = final.jupyterlabWith {
    # kernels = [ ansible bash c cpp go haskell javascript nix ocaml python r ruby rust ];
    kernels = [ ansible bash c cpp go haskell javascript nix python r ruby rust ];
    directory = "./jupyterlab";
  };
}
