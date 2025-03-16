final: prev:
{

  # pythonEnv = prev.python3.withPackages (ps: with ps; [ jupyter prettytable ]);

  # python3 = prev.python3.override {
  #   packageOverrides = pyFinal: pyPrev: {
  #     prettytable = pyPrev.prettytable.overridePythonAttrs (oldAttrs: {
  #       ...
  #     });
  #   };
  # };

  # python3Packages = prev.python3Packages // {
  #   ansible-core = prev.python3Packages.ansible-core.override ({
  #     ansible = final.python3Packages.ansible.overridePythonAttrs (oldAttrs: {
  #       preferLocalBuild = true;
  #       propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ [ final.python3Packages.prettytable ];
  #     });
  #   });
  # };

}
