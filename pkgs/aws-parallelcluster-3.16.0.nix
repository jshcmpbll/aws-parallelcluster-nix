# AWS ParallelCluster v3.16.0 (current working version)
{ 
  lib,
  callPackage,
  marshmallow-compat
}:

let
  buildParallelCluster = callPackage ./aws-parallelcluster-version.nix { };
in

buildParallelCluster {
  version = "3.16.0";
  hash = "sha256-rY2SZ3GaBJ/AMLeH+XnvnPo8zLVa5+R+0fQViRj/C9s=";
  compatMarshmallow = marshmallow-compat;
  pythonMinVersion = "3.9";
  
  # No extra patches needed for 3.16.0 (already working)
  extraPatches = [];
}