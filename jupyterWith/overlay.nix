self: final: prev:

let
  ansible = final.jupyterWith.kernels.ansibleKernel {
    name = "Ansible";
  };

  bash = final.jupyterWith.kernels.bashKernel {
    name = "Bash";
  };

  c = final.jupyterWith.kernels.cKernelWith {
    name = "C";
    packages = p: with p; [ ];
  };

  cpp = final.jupyterWith.kernels.xeusCling {
    name = "C++";
  };

  go = final.jupyterWith.kernels.gophernotes {
    name = "Go";
  };

  haskell = final.jupyterWith.kernels.iHaskellWith {
    name = "Haskell";
    packages = p: with p; [ formatting ];
    # Optional definition of `haskellPackages` to be used.
    haskellPackages = final.haskellPackages;
  };

  javascript = final.jupyterWith.kernels.iJavascript {
    name = "Javascript";
  };

  nix = final.jupyterWith.kernels.iNixKernel {
    name = "Nix";
  };

  ocaml = final.jupyterWith.kernels.ocamlWith {
    name = "OCaml";
    packages = with final; [ ];
  };

  python = final.jupyterWith.kernels.iPythonWith {
    name = "Python";
    packages = p: with p; [ numpy sympy pandas ];
    # Optional definition of `python3` to be used.
    python3 = final.python3;
    ignoreCollisions = true;
  };

  r = final.jupyterWith.kernels.iRWith {
    name = "R";
    packages = p: with p; [ ggplot2 ];
    # Optional definition of `rPackages` to be used.
    rPackages = final.rPackages;
  };

  ruby = final.jupyterWith.kernels.iRubyWith {
    name = "Ruby";
    packages = p: with p; [ ];
  };

  rust = final.jupyterWith.kernels.rustWith {
    name = "Rust";
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
