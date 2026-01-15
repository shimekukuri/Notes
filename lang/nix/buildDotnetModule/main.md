# Nix lang - buildDotnetModule

## Abstract
### Nix Manual

### AI
In 2026, generating NuGet dependencies for Nix is primarily done through the buildDotnetModule helper in nixpkgs.
There are two main methods: the automated fetch-deps script and the manual nuget-to-json tool.
1. The Automated Method (fetch-deps)
This is the preferred method for buildDotnetModule.
Define your package: Create a default.nix or flake that uses buildDotnetModule. Set the nugetDeps attribute to a
placeholder path (e.g., ./deps.json).
nix
buildDotnetModule {
  pname = "my-app";
  version = "1.0.0";
  src = ./.;
  projectFile = "./MyProject.csproj";
  nugetDeps = ./deps.json; # This file doesn't exist yet
}
Use code with caution.

Generate the script: Run the following command to build the dependency generation script:
nix-build -A package.fetch-deps (if using a standard nix file).
nix build .#my-app.passthru.fetch-deps (if using flakes).
Run the script: Execute the generated script (usually found at ./result). This will restore your project's NuGet
packages and write a fixed-output deps.json file to the path you specified.

## Directory

## Useful Links

## Tags
