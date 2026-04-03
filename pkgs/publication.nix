{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "publication";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-aEFqDedt3c3Skw0cjvhTp0PMlsgkFsTk07XZAcYnbcQ=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "publication" ];

  # No tests in the source
  doCheck = false;

  meta = with lib; {
    description = "Publication quality figures in matplotlib";
    homepage = "https://pypi.org/project/publication/";
    license = licenses.bsd3;
    maintainers = [ maintainers.jshcmpbll ];
  };
}