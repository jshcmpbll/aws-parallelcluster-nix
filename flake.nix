{
  description = "AWS ParallelCluster with CDK v1 dependencies for Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      # Our custom Python package overlay
      pythonOverlay = final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            # Core dependencies
            publication = python-final.callPackage ./pkgs/publication.nix { };
            jsii = python-final.callPackage ./pkgs/jsii.nix { };
            marshmallow-compat = python-final.callPackage ./pkgs/marshmallow-compat.nix { };
            
            # AWS CDK v1 packages
            aws-cdk-core = python-final.callPackage ./pkgs/aws-cdk-core.nix { };
            aws-cdk-aws-batch = python-final.callPackage ./pkgs/aws-cdk-aws-batch.nix { };
            aws-cdk-aws-cloudwatch = python-final.callPackage ./pkgs/aws-cdk-aws-cloudwatch.nix { };
            aws-cdk-aws-ec2 = python-final.callPackage ./pkgs/aws-cdk-aws-ec2.nix { };
            aws-cdk-aws-iam = python-final.callPackage ./pkgs/aws-cdk-aws-iam.nix { };
            aws-cdk-aws-lambda = python-final.callPackage ./pkgs/aws-cdk-aws-lambda.nix { };
            aws-cdk-aws-logs = python-final.callPackage ./pkgs/aws-cdk-aws-logs.nix { };
            aws-cdk-aws-ssm = python-final.callPackage ./pkgs/aws-cdk-aws-ssm.nix { };
            
            # AWS ParallelCluster versions
            aws-parallelcluster = python-final.callPackage ./pkgs/aws-parallelcluster.nix { 
              marshmallow = python-final.marshmallow-compat;
            };
            aws-parallelcluster-3_9_2 = python-final.callPackage ./pkgs/aws-parallelcluster-3.9.2.nix { 
              marshmallow-compat = python-final.marshmallow-compat;
            };
            aws-parallelcluster-3_16_0 = python-final.callPackage ./pkgs/aws-parallelcluster-3.16.0.nix { 
              marshmallow-compat = python-final.marshmallow-compat;
            };
          })
        ];
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        customPkgs = pkgs.extend pythonOverlay;
      in
      {
        packages = {
          default = customPkgs.python3.pkgs.aws-parallelcluster;
          aws-parallelcluster = customPkgs.python3.pkgs.aws-parallelcluster;
          aws-parallelcluster-3_9_2 = customPkgs.python3.pkgs.aws-parallelcluster-3_9_2;
          aws-parallelcluster-3_16_0 = customPkgs.python3.pkgs.aws-parallelcluster-3_16_0;
          
          # Individual packages for testing
          jsii = customPkgs.python3.pkgs.jsii;
          publication = customPkgs.python3.pkgs.publication;
          marshmallow-compat = customPkgs.python3.pkgs.marshmallow-compat;
          aws-cdk-core = customPkgs.python3.pkgs.aws-cdk-core;
          aws-cdk-aws-batch = customPkgs.python3.pkgs.aws-cdk-aws-batch;
          aws-cdk-aws-cloudwatch = customPkgs.python3.pkgs.aws-cdk-aws-cloudwatch;
          aws-cdk-aws-ec2 = customPkgs.python3.pkgs.aws-cdk-aws-ec2;
          aws-cdk-aws-iam = customPkgs.python3.pkgs.aws-cdk-aws-iam;
          aws-cdk-aws-lambda = customPkgs.python3.pkgs.aws-cdk-aws-lambda;
          aws-cdk-aws-logs = customPkgs.python3.pkgs.aws-cdk-aws-logs;
          aws-cdk-aws-ssm = customPkgs.python3.pkgs.aws-cdk-aws-ssm;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with customPkgs; [
            python3
            python3.pkgs.aws-parallelcluster
          ];
        };
      }
    ) // {
      # Expose the overlay for use in other flakes  
      overlays.default = pythonOverlay;
    };
}