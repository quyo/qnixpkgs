self: final: prev:

let
  inherit (final.jupyterWith) kernels;

  iPython = kernels.iPythonWith {
    name = "python";
    packages = p: with p; [ numpy sympy ];
    ignoreCollisions = true;
  };

  iHaskell = kernels.iHaskellWith {
    name = "haskell";
    packages = p: with p; [ hvega formatting ];
  };
in

{
  jupyterEnvironment = final.jupyterlabWith {
    kernels = [ iPython iHaskell ];
    # directory = "./jupyterlab";
  };
}
