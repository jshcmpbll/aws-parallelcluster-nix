{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pythonRelaxDepsHook,
  attrs,
  cattrs,
  importlib-resources,
  publication,
  python-dateutil,
  typeguard,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "jsii";
  version = "1.85.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t3GUzwU8Bsa9/8iHpNHSpBETxvR4Cn141wp4CnCZgAg=";
  };

  nativeBuildInputs = [ 
    setuptools 
    pythonRelaxDepsHook
  ];
  
  pythonRelaxDeps = [
    "attrs"
    "cattrs"
    "typeguard"
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    importlib-resources
    publication
    python-dateutil
    typeguard
    typing-extensions
  ];

  pythonImportsCheck = [ "jsii" ];

  # Tests require network access
  doCheck = false;
  
  # Patch setup files to relax setuptools version requirement and other version constraints
  postPatch = ''
    find . -name "*.py" -o -name "*.cfg" -o -name "*.toml" | xargs grep -l "setuptools~=62.2" | xargs sed -i 's/setuptools~=62.2/setuptools/' || true
    find . -name "pyproject.toml" | xargs sed -i 's/setuptools~=62.2/setuptools/' || true
    find . -name "setup.cfg" | xargs sed -i 's/setuptools~=62.2/setuptools/' || true
    # Also relax attrs and cattrs version constraints
    find . -name "*.cfg" | xargs sed -i 's/attrs<25.0,>=21.2/attrs/' || true
    find . -name "*.cfg" | xargs sed -i 's/cattrs<24.2,>=1.8/cattrs/' || true
  '';
  
  # Use pythonRelaxDepsHook to handle version constraint conflicts

  meta = with lib; {
    description = "JavaScript interop interface";
    homepage = "https://github.com/aws/jsii";
    license = licenses.asl20;
    maintainers = [ maintainers.jshcmpbll ];
  };
}