# Clayton Stories VR-2141 - flakee

## Abstract
```c
         88                                                                                               88
         88                                                                      ,d                       88
         88                                                                      88                       88
 ,adPPYb,88  ,adPPYba, 8b,dPPYba,  8b,dPPYba,  ,adPPYba,  ,adPPYba, ,adPPYYba, MM88MMM ,adPPYba,  ,adPPYb,88
a8"    `Y88 a8P_____88 88P'    "8a 88P'   "Y8 a8P_____88 a8"     "" ""     `Y8   88   a8P_____88 a8"    `Y88
8b       88 8PP""""""" 88       d8 88         8PP""""""" 8b         ,adPPPPP88   88   8PP""""""" 8b       88
"8a,   ,d88 "8b,   ,aa 88b,   ,a8" 88         "8b,   ,aa "8a,   ,aa 88,    ,88   88,  "8b,   ,aa "8a,   ,d88
 `"8bbdP"Y8  `"Ybbd8"' 88`YbbdP"'  88          `"Ybbd8"'  `"Ybbd8"' `"8bbdP"Y8   "Y888 `"Ybbd8"'  `"8bbdP"Y8
                       88
                       88
```

```nix
{
  description = "ASP.NET Core 8 API image (Nix-built publish) with corporate CA";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Plain paths; mark as non-flake so Nix doesn't expect flake.nix inside them.
    src.url = "path:./src";                src.flake = false;
    certs.url = "path:./certs";            certs.flake = false;
    nugetConfig.url = "path:./nuget.config"; nugetConfig.flake = false;

    # Optional: pin NuGet deps via input (if you want file outside repo)
    # nugetDeps.url = "path:./deps.json"; nugetDeps.flake = false;
  };

  outputs = { self, nixpkgs, src, certs, nugetConfig /*, nugetDeps*/ }:
  let
    # Support macOS + Linux so `nix develop` works locally on Apple Silicon.
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    lib = (import nixpkgs { system = "x86_64-linux"; }).lib;
  in
  {
    # -----------------------
    # Packages (Docker image)
    # -----------------------
    packages = lib.genAttrs systems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Build the app from source with pinned NuGet deps
        app = pkgs.buildDotnetModule {
          pname = "cmh-vmf-rmktg-externalgateway-api";
          version = "0.1.0";

          src = src;
          projectFile = "Api/CMH.VMF.RMKTG.ExternalGateway.Api/CMH.VMF.RMKTG.ExternalGateway.Api.csproj";

          dotnet-sdk     = pkgs.dotnetCorePackages.sdk_8_0;
          dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;

          # Use a pinned deps.json checked into your repo:
          nugetDeps = ./deps.json;
          # Or, if you enabled the flake input above:
          # nugetDeps = nugetDeps;

          # If you must influence restore (rare with nugetDeps), you could add:
          # dotnetRestoreFlags = [ "--configfile ${nugetConfig}" ];
        };

        appRoot = pkgs.runCommand "app-root" {} ''
          mkdir -p $out/app
          cp -r ${app}/* $out/app/
        '';

        certRoot = pkgs.runCommand "cert-root" {} ''
          set -eu
          mkdir -p $out/usr/local/share/ca-certificates
          if [ -d ${certs} ]; then
            # "." copies contents of the directory, not the directory itself
            cp -r ${certs}/. $out/usr/local/share/ca-certificates/
          fi
        '';

        aspnetBase = pkgs.dockerTools.pullImage {
          imageName = "mcr.microsoft.com/dotnet/aspnet";
          # imageTag  = "8.0";  # Prefer digest for reproducibility
          os          = "linux";
          arch        = "arm64";
          imageDigest = "sha256:bf0c0d65ef90a2b60c031dfd0404000dcecf756f3c5d7b016840c7d011c030fb";
          sha256      = "sha256-5a/WgiEoSq742Xo3VaxCG3rQGDgPU531G4a6tosMUzM=";
        };
      in
      {
        externalGateway = pkgs.dockerTools.buildImage {
          name = "external-gateway-api";
          tag  = "v0.1.0";
          fromImage = aspnetBase;

          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ appRoot certRoot ];
            pathsToLink = [ "/" ];
          };

          # On macOS builders, this may fail due to lack of KVM; remove if needed.
          runAsRoot = ''
            #!${pkgs.runtimeShell}
            if command -v update-ca-certificates >/dev/null 2>&1; then
              update-ca-certificates
            fi
          '';

          config = {
            Env = [
              "ASPNETCORE_ENVIRONMENT=Production"
              "ASPNETCORE_URLS=http://+:8080"
            ];
            ExposedPorts = { "8080/tcp" = {}; };
            WorkingDir = "/app";
            Cmd = [ "dotnet" "/app/CMH.VMF.RMKTG.ExternalGateway.Api.dll" ];
          };
        };

        # Optional aliases for convenience
        api-docker = self.packages.${system}.externalGateway;
        default    = self.packages.${system}.externalGateway;
      }
    );

    # -----------------------
    # Dev shells (per system)
    # -----------------------
    devShells = lib.genAttrs systems (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        default = pkgs.mkShell {
          name = "aspnet8-dev";
          packages = [
            # Use a single SDK or combine multiple if needed:
            (with pkgs.dotnetCorePackages; combinePackages [ sdk_8_0 ])
            pkgs.nuget-to-json
          ];
        };
      }
    );

    # -----------------------
    # Apps (CLI helpers)
    # -----------------------
    apps = lib.genAttrs systems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Generator WITHOUT nuget.config
        fetchDepsNoConfig = pkgs.writeShellScriptBin "fetch-deps" ''
          set -euo pipefail
          REPO_ROOT="$(pwd)"
          RESTORE_DIR="$REPO_ROOT/.nix-nuget-out"
          rm -rf "$RESTORE_DIR"
          mkdir -p "$RESTORE_DIR"

          echo "[info] Restoring NuGet packages into: $RESTORE_DIR"
          dotnet restore --packages "$RESTORE_DIR"

          echo "[info] Converting restored packages to deps.json"
          nuget-to-json "$RESTORE_DIR" > "$REPO_ROOT/deps.json"

          echo "[info] Wrote $REPO_ROOT/deps.json"
          echo "[done]"
        '';

        # Generator WITH repo nuget.config (ensure it contains NO secrets)
        fetchDepsWithConfig = pkgs.writeShellScriptBin "fetch-deps-with-config" ''
          set -euo pipefail
          REPO_ROOT="$(pwd)"
          RESTORE_DIR="$REPO_ROOT/.nix-nuget-out"
          rm -rf "$RESTORE_DIR"
          mkdir -p "$RESTORE_DIR"

          CONFIG_PATH="$REPO_ROOT/nuget.config"
          if [ ! -f "$CONFIG_PATH" ]; then
            echo "[error] nuget.config not found at $CONFIG_PATH"
            exit 1
          fi

          echo "[info] Restoring with config: $CONFIG_PATH"
          dotnet restore --packages "$RESTORE_DIR" --configfile "$CONFIG_PATH"

          echo "[info] Converting restored packages to deps.json"
          nuget-to-json "$RESTORE_DIR" > "$REPO_ROOT/deps.json"

          echo "[info] Wrote $REPO_ROOT/deps.json"
          echo "[done]"
        '';
      in
      {
        fetch-deps             = { type = "app"; program = "${fetchDepsNoConfig}/bin/fetch-deps"; };
        fetch-deps-with-config = { type = "app"; program = "${fetchDepsWithConfig}/bin/fetch-deps-with-config"; };
      }
    );
  };
}
```

## Directory

## Useful Links

## Tags
