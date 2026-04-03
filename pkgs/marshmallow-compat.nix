{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  python-dateutil,
  packaging,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "marshmallow";
  version = "3.19.0";  # Compatible version with ParallelCluster
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kAMsD9ZQzpS27G3I3+sOP/UMFEWGRiw4m4GgcgW+23g=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    packaging
  ] ++ lib.optionals (pythonOlder "3.8") [
    python-dateutil
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "marshmallow" ];

  meta = with lib; {
    description = "A lightweight library for converting complex datatypes to and from native Python datatypes (compatible version)";
    homepage = "https://github.com/marshmallow-code/marshmallow";
    license = licenses.mit;
    maintainers = [ maintainers.jshcmpbll ];
  };
}