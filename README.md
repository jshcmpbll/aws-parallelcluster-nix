# AWS ParallelCluster Nix

A Nix flake providing AWS ParallelCluster and its legacy CDK v1 dependencies.

## Overview

This repository provides a working Nix derivation for AWS ParallelCluster, which requires deprecated AWS CDK v1 packages that are not available in nixpkgs. Since CDK v1 reached end-of-support in June 2023 and has version compatibility issues with modern Python dependencies, these packages are unlikely to be accepted into nixpkgs.

## Packages Included

### Core Package
- **aws-parallelcluster** - AWS ParallelCluster CLI for managing HPC clusters in AWS

### Dependencies
- **jsii** (v1.85.0) - JavaScript/TypeScript interop interface
- **publication** (v0.0.3) - Required by jsii
- **aws-cdk-core** (v1.164.0) - Core CDK functionality
- **AWS CDK Service Packages** (all v1.164.0):
  - aws-cdk-aws-batch
  - aws-cdk-aws-cloudwatch
  - aws-cdk-aws-ec2
  - aws-cdk-aws-iam
  - aws-cdk-aws-lambda
  - aws-cdk-aws-logs
  - aws-cdk-aws-ssm

## Usage

## Multiple Versions Available

This flake provides multiple versions of AWS ParallelCluster:

- **`aws-parallelcluster`** (default) - Latest supported version (3.16.0)
- **`aws-parallelcluster-3_16_0`** - Version 3.16.0 (fully working)
- **`aws-parallelcluster-3_9_2`** - Version 3.9.2 (fully working)

### Using the Flake Directly

```bash
# Install AWS ParallelCluster (latest)
nix profile install github:jshcmpbll/aws-parallelcluster-nix

# Install specific version
nix profile install github:jshcmpbll/aws-parallelcluster-nix#aws-parallelcluster-3_16_0

# Or run directly without installing
nix run github:jshcmpbll/aws-parallelcluster-nix

# Run specific version
nix run github:jshcmpbll/aws-parallelcluster-nix#aws-parallelcluster-3_16_0 -- --help

# Or enter a development shell with ParallelCluster available
nix develop github:jshcmpbll/aws-parallelcluster-nix
```

### Using in Your Own Flake

Add this to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    aws-parallelcluster-nix.url = "github:jshcmpbll/aws-parallelcluster-nix";
  };
  
  outputs = { self, nixpkgs, aws-parallelcluster-nix }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          aws-parallelcluster-nix.packages.${system}.aws-parallelcluster
        ];
      };
    };
}
```

### Using the Overlay

You can also use the provided overlay to integrate these packages into your own nixpkgs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    aws-parallelcluster-nix.url = "github:jshcmpbll/aws-parallelcluster-nix";
  };
  
  outputs = { self, nixpkgs, aws-parallelcluster-nix }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system}.extend aws-parallelcluster-nix.overlays.default;
    in {
      packages.${system} = {
        aws-parallelcluster = pkgs.python3.pkgs.aws-parallelcluster;
      };
    };
}
```

## Building from Source

```bash
# Clone the repository
git clone https://github.com/jshcmpbll/aws-parallelcluster-nix.git
cd aws-parallelcluster-nix

# Build the package
nix build

# Or build specific components
nix build .#jsii
nix build .#aws-cdk-core
nix build .#aws-parallelcluster
```

## Known Issues

- **Version Constraints**: The legacy CDK v1 packages have strict version constraints that conflict with modern Python dependencies in nixpkgs. Runtime dependency checking is disabled to work around this.
- **Functionality**: While the package builds successfully, some functionality may be limited due to the version mismatches.
- **Maintenance**: Since CDK v1 is deprecated, this package is for legacy support only and should be migrated to CDK v2 when AWS ParallelCluster supports it.

## Repository Structure

```
.
├── flake.nix              # Main flake definition
├── pkgs/                  # Package definitions
│   ├── aws-parallelcluster.nix
│   ├── jsii.nix
│   ├── publication.nix
│   ├── aws-cdk-core.nix
│   ├── aws-cdk-aws-batch.nix
│   ├── aws-cdk-aws-cloudwatch.nix
│   ├── aws-cdk-aws-ec2.nix
│   ├── aws-cdk-aws-iam.nix
│   ├── aws-cdk-aws-lambda.nix
│   ├── aws-cdk-aws-logs.nix
│   └── aws-cdk-aws-ssm.nix
└── README.md
```

## Contributing

Since this is a compatibility package for legacy software, contributions should focus on:
- Fixing build issues
- Adding missing CDK service packages if needed
- Improving documentation

## License

This repository follows the same license as the packaged software. AWS ParallelCluster is licensed under Apache 2.0.

## Disclaimer

This is an unofficial packaging effort. AWS ParallelCluster is a trademark of Amazon Web Services, Inc.
