# AWS ParallelCluster v3.9.2
{ 
  lib,
  callPackage,
  marshmallow-compat,
  setuptools
}:

let
  buildParallelCluster = callPackage ./aws-parallelcluster-version.nix { };
in

buildParallelCluster {
  version = "3.9.2";
  hash = "sha256-KyZk4f3nrs3GZsv78dyZ9xD1W9BP6BGW8hNdda1vnAY=";
  compatMarshmallow = marshmallow-compat;
  # Use default connexion but patch the imports
  pythonMinVersion = "3.8";  # 3.9.2 supported older Python versions
  
  # Version 3.9.2 needs setuptools runtime for pkg_resources
  extraDeps = [ setuptools ];
  
  # Version 3.9.2 may need additional patches for older compatibility
  extraPatches = [
    "# v3.9.2 needs setuptools to provide pkg_resources and connexion compatibility"
    "# Fix connexion imports that changed between v2 and v3"
    "find . -name '*.py' -exec sed -i 's/from connexion\\.apps\\.flask_app import FlaskJSONEncoder/class FlaskJSONEncoder: pass/g' {} \\; || true"
  ];
}