self: final: prev:
{
  my-project = final.hello;
  my-project-devenv = final.buildEnv
    {
      name = "my-project-devenv";
      paths = with final; [ fortune cowsay lolcat ];
    };
}
