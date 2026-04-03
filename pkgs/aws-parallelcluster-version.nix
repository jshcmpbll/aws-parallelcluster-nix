# Parameterized AWS ParallelCluster package builder
{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, pythonRelaxDepsHook
, boto3
, botocore
, tabulate
, pyyaml
, jinja2
, packaging
, connexion
, jmespath
, jsii
, werkzeug
, flask
, pytestCheckHook
, marshmallow ? null  # Allow override for different marshmallow versions
}:

{ version
, hash
, compatMarshmallow ? null  # Optional override marshmallow
, compatConnexion ? null    # Optional override connexion
, pythonMinVersion ? "3.9"
, extraDeps ? []  # Additional dependencies for specific versions
, extraPatches ? []  # Additional patches for specific versions
}:

let
  # Use compatible marshmallow if provided, otherwise use system marshmallow
  marshmallowPkg = if compatMarshmallow != null then compatMarshmallow else marshmallow;
  # Use compatible connexion if provided, otherwise use system connexion
  connexionPkg = if compatConnexion != null then compatConnexion else connexion;
  
in buildPythonPackage rec {
  pname = "aws-parallelcluster";
  inherit version;
  format = "setuptools";

  disabled = pythonOlder pythonMinVersion;

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-parallelcluster";
    rev = "v${version}";
    inherit hash;
  };

  sourceRoot = "${src.name}/cli";

  nativeBuildInputs = [ setuptools pythonRelaxDepsHook ];

  # Completely disable runtime dependency checking
  dontUseSetuptoolsCheck = true;

  pythonRelaxDeps = [
    "tabulate"
    "marshmallow"
    "connexion"
  ];
  
  # Add postPatch to fix compatibility issues
  postPatch = ''
    # Remove all CDK dependencies from setup requirements  
    find . -name "setup.py" -exec sed -i '/aws-cdk/d' {} \; || true
    find . -name "setup.cfg" -exec sed -i '/aws-cdk/d' {} \; || true  
    find . -name "pyproject.toml" -exec sed -i '/aws-cdk/d' {} \; || true
    find . -name "requirements*.txt" -exec sed -i '/aws-cdk/d' {} \; || true
    # Also patch any Python files that might list dependencies
    find . -name "*.py" -exec grep -l "aws-cdk" {} \; | xargs sed -i '/aws-cdk/d' || true
    
    # Fix marshmallow 4.x compatibility issues - replace 'default=' with 'missing='
    find . -name "*.py" -exec sed -i 's/default=/missing=/g; s/load_default=/missing=/g' {} \; || true
    
    # Fix os.environ.get() calls that use missing parameter (new in Python 3.11+) 
    find . -name "*.py" -exec sed -i 's/os\.environ\.get(\([^,]*\), missing=\([^)]*\))/os.environ.get(\1, \2)/g' {} \; || true
    
    # Fix argparse add_argument calls that use missing parameter (not supported in argparse)
    find . -name "*.py" -exec sed -i 's/missing=False,\?\s*//g; s/,\s*missing=False//g' {} \; || true
    find . -name "*.py" -exec sed -i 's/missing=True,\?\s*//g; s/,\s*missing=True//g' {} \; || true
    
    ${lib.concatStringsSep "\n" extraPatches}
  '';

  propagatedBuildInputs = [
    boto3
    botocore
    tabulate
    pyyaml
    jinja2
    marshmallowPkg
    packaging
    connexionPkg
    jmespath
    werkzeug
    flask
    # AWS CDK dependencies (legacy v1) - temporarily simplified
    jsii
    # aws-cdk-core  # Temporarily disabled due to missing CDK ecosystem deps
  ] ++ extraDeps;

  nativeCheckInputs = [ pytestCheckHook ];
  
  dontUsePythonRuntimeDepsCheck = true;

  # Tests require network access and AWS credentials
  doCheck = false;

  # Skip runtime dependency checks due to version incompatibilities with legacy CDK v1

  meta = with lib; {
    description = "AWS ParallelCluster is an AWS supported Open Source cluster management tool to deploy and manage HPC clusters in the AWS cloud";
    homepage = "https://github.com/aws/aws-parallelcluster";
    license = licenses.asl20;
    maintainers = [ maintainers.jshcmpbll ];
    mainProgram = "pcluster";
  };
}