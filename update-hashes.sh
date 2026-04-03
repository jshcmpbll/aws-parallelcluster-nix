#!/usr/bin/env bash
# Script to update package hashes
set -euo pipefail

echo "Updating hashes for AWS ParallelCluster Nix packages..."

# List of packages that need hash updates
packages=(
    "aws-cdk-aws-batch"
    "aws-cdk-aws-cloudwatch"
    "aws-cdk-aws-ec2"
    "aws-cdk-aws-iam"
    "aws-cdk-aws-lambda"
    "aws-cdk-aws-logs"
    "aws-cdk-aws-ssm"
)

for package in "${packages[@]}"; do
    echo "Building $package to get correct hash..."
    if output=$(nix build ".#$package" 2>&1); then
        echo "$package: Build succeeded"
    else
        # Extract the correct hash from error message
        if correct_hash=$(echo "$output" | grep -oP "got:\s+\Ksha256-[A-Za-z0-9+/=]+"); then
            echo "$package: Updating hash to $correct_hash"
            sed -i "s/sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=/$correct_hash/" "pkgs/$package.nix"
        else
            echo "$package: Could not extract hash from build output"
        fi
    fi
done

echo "Hash update complete. You may need to run this script multiple times if packages depend on each other."