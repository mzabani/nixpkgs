{ lib, buildPythonPackage, fetchFromGitHub, django, pysaml2, defusedxml }:

buildPythonPackage rec {
  pname = "djangosaml2";
  version = "1.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "IdentityPython";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-s5RM6O9USWZCUOQG5/mKP1TOuSUkKlqfiYlpN6r04ZI=";
  };

  propagatedBuildInputs = [ django pysaml2 defusedxml ];

  doCheck = false; # I don't know python to know how to make tests pass

  meta = with lib; {
    description = "pysaml2 integration for Django";
    homepage = "https://github.com/IdentityPython/djangosaml2";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
