{ lib, stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "checkexec";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "kurtbuilds";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-osLtyVXR4rASwRJmbu6jD8o3h12l/Ty4O8/XTl5UzB4=";
  };

  cargoHash = "sha256-TqmcIyokNM4SnopnzzfM6yyZQz79BIxTY38XjGsnj+s=";
}
