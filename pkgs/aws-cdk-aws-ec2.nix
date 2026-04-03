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
  pname = "aws-cdk.aws-ec2";
  version = "1.164.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oB8/NX9nhEvaNE/Fej7bFYvZyR39oJerETjplJDh5MU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jsii
    aws-cdk-core
    python-dateutil
    typing-extensions
  ];

  pythonImportsCheck = [ "aws_cdk.aws_ec2" ];

  # Tests require network access and AWS credentials
  doCheck = false;

  # Skip runtime dependency checks for legacy CDK v1
  dontUsePythonRuntimeDepsCheck = true;

  meta = with lib; {
    description = "The CDK Construct Library for AWS EC2";
    homepage = "https://github.com/aws/aws-cdk";
    license = licenses.asl20;
    maintainers = [ maintainers.jshcmpbll ];
  };
}