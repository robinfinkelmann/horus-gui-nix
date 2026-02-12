# toolz.nix
{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  poetry-core,
  cffi,
  requests,
  asn1tools,
  audioop-lts,
  python-dateutil,
}:

let
  # horusdemodlib requires asn1tools = "^0.165.0", while nixpkgs is at asn1tools = ">=0.167.0"
  asn1tools-0_165_0 = asn1tools.overridePythonAttrs (old: rec {
    version = "0.165.0";
    src = fetchPypi {
      pname = "asn1tools";
      inherit version;
      hash = "sha256-L6Y9gEXQ2qLNSIVar9OawZaB+T6y85UxnP5sdF6sUhY="; 
    };
  });
in
buildPythonPackage rec {

  pname = "horusdemodlib";
  version = "0.6.1";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2yAQPp+Rs/BQKDV04X+iVmDzzAmcxoGpW4L26duusX0=";
  };

  #do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = true;

  build-system = [
    setuptools
    wheel
    poetry-core
  ];

  dependencies = [
    cffi
    requests
    asn1tools-0_165_0
    audioop-lts
    python-dateutil
  ];
}
