self: final: prev:

let
  iPython = final.jupyterWith.kernels.iPythonWith {
    name = "python";
    packages = p: with p; [ numpy sympy ];
    ignoreCollisions = true;
  };

  iHaskell = final.jupyterWith.kernels.iHaskellWith {
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
