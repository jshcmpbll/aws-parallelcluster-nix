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
  pname = "aws-cdk.aws-logs";
  version = "1.164.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/r9mckgDuxF+rAV8HLheNrmD6ySe8Q46MB7XQikvw5E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jsii
    aws-cdk-core
    python-dateutil
    typing-extensions
  ];

  pythonImportsCheck = [ "aws_cdk.aws_logs" ];

  # Tests require network access and AWS credentials
  doCheck = false;

  # Skip runtime dependency checks for legacy CDK v1
  dontUsePythonRuntimeDepsCheck = true;

  meta = with lib; {
    description = "The CDK Construct Library for AWS CloudWatch Logs";
    homepage = "https://github.com/aws/aws-cdk";
    license = licenses.asl20;
    maintainers = [ maintainers.jshcmpbll ];
  };
}