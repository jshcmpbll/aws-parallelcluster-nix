{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  pythonRelaxDepsHook,
  jsii,
  python-dateutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aws-cdk.core";
  version = "1.164.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fZYzyCI0RPyglgQz0CMrhPx0UAsiMKHzKuLm4A7z/s8=";
  };

  nativeBuildInputs = [ 
    setuptools
    pythonRelaxDepsHook
  ];
  
  pythonRelaxDeps = [
    "setuptools"
    "wheel"
  ];

  propagatedBuildInputs = [
    jsii
    python-dateutil
    typing-extensions
  ];

  # Patch setup files to relax version requirements
  postPatch = ''
    find . -name "*.py" -o -name "*.cfg" -o -name "*.toml" | xargs grep -l "setuptools~=62.1.0" | xargs sed -i 's/setuptools~=62.1.0/setuptools/' || true
    find . -name "*.py" -o -name "*.cfg" -o -name "*.toml" | xargs grep -l "wheel~=0.37.1" | xargs sed -i 's/wheel~=0.37.1/wheel/' || true
  '';

  pythonImportsCheck = [ "aws_cdk.core" ];

  # Tests require network access and AWS credentials
  doCheck = false;

  # Skip runtime dependency checks for missing CDK dependencies
  dontUsePythonRuntimeDepsCheck = true;

  meta = with lib; {
    description = "The CDK Construct Library for AWS CloudFormation Resources";
    homepage = "https://github.com/aws/aws-cdk";
    license = licenses.asl20;
    maintainers = [ maintainers.jshcmpbll ];
  };
}