# toolz.nix
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  poetry,
  poetry-core,
  requests,
  pyqt6,
  pyqtgraph,
  pyaudio,
  horusdemodlib,
}:

buildPythonPackage rec {

  pname = "horus-gui";
  version = "v0.6.1";
  src = fetchFromGitHub {
    owner = "projecthorus";
    repo = "horus-gui";
    rev = version;
    sha256 = "sha256-CrQVmdAJZ2751ymPuaUn7is5/XC5G3capRUFsw9hnyo=";
  };

  # uncleanly patch pyproject.toml to build with poetry-core, TODO prettify
  postPatch = ''
    sed -i 's/poetry.masonry/poetry.core.masonry/g' pyproject.toml
    sed -i 's/"poetry>=0.12"//g' pyproject.toml
  '';

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
    requests
    pyqt6
    pyqtgraph
    pyaudio
    horusdemodlib
  ];
}
