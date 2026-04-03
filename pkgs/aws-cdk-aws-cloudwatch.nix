{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  jsii,
  aws-cdk-core,
  python-dateutil,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aws-cdk.aws-cloudwatch";
  version = "1.164.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9jwUtdehMHRdq2rJ4wID+4ucFG4I+GjZoOm/kOw4uBU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jsii
    aws-cdk-core
    python-dateutil
    typing-extensions
  ];

  pythonImportsCheck = [ "aws_cdk.aws_cloudwatch" ];

  # Tests require network access and AWS credentials
  doCheck = false;

  # Skip runtime dependency checks for legacy CDK v1
  dontUsePythonRuntimeDepsCheck = true;

  meta = with lib; {
    description = "The CDK Construct Library for AWS CloudWatch";
    homepage = "https://github.com/aws/aws-cdk";
    license = licenses.asl20;
    maintainers = [ maintainers.jshcmpbll ];
  };
}