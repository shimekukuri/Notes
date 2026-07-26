# Projects - Zixia

## Abstract
Entry point for my nix k8s teraform deployment toolkit


### Todo
- I need to find out how I can automate getting my containers up into Codeberg
    - SopNix?????

### NEW PLAN 
Create a DAG! No particular lifetime of anything involved no hooks just a graph that is traversed in a give order based
upon depends on relationships.This may also help it more generic to interact with things just beyond k8s and more 
generally applicable 

### phases 
I think that this should actully be more so modeled after The life cycle hooks found in nix 

prePhases (An array of hooks run before the entire sequence starts)
preUnpack -> unpackPhase -> postUnpack (Extracts source files)
prePatch -> patchPhase -> postPatch (Applies source code patches)
preConfigure -> configurePhase -> postConfigure (Runs scripts like ./configure)
preBuild -> buildPhase -> postBuild (Compiles the code, usually via make)
preCheck -> checkPhase -> postCheck (Runs unit tests if doCheck = true;)
preInstall -> installPhase -> postInstall (Copies binaries to the $out directory)
preFixup -> fixupPhase -> postFixup (Strips binaries, patches RPATHs, shrinks files)
preInstallCheck -> installCheckPhase -> postInstallCheck (Runs post-install tests if doInstallCheck = true;)
postPhases (An array of hooks run after all phases are complete)


### phases(LLM)
[ Phase 1: Build Local ]   -> Fails fast if any compiler error occurs
        │
[ Phase 2: Pre-Infra ]     -> DB backups, migration preparation, DNS prep
        │
[ Phase 3: Infra Apply ]   -> Terraform runs, cluster/registry state convergence
        │
[ Phase 4: Registry Push ] -> Skopeo mirrors Nix store images to remote registry
        │
[ Phase 5: App Apply ]     -> Kubenix manifests injected into Kubernetes
        │
[ Phase 6: Post-Deploy ]   -> Health checks, cache clearing, webhook notif

```nix
# services/auth-api/flake.nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    # Phase 1: Pure local store compilation
    packages.${system}.container = pkgs.dockerTools.buildLayeredImage {
      name = "auth-api";
      config.Cmd = [ "./auth-bin" ];
    };

    # The granular hooks this flake cares about
    lifecycleHooks = {
      preInfra = ''
        echo "[auth-api] Ensuring vault secrets are initialized..."
      '';

      infraApply = ''
        echo "[auth-api] Running component-specific terraform if needed..."
      '';

      appApply = ''
        echo "[auth-api] Applying Kubenix templates to cluster..."
        # Your Kubenix deployment execution here
      '';

      postDeploy = ''
        echo "[auth-api] Verifying endpoint health..."
        curl -f https://cluster.local
      '';
    };
  };
}
```
```nix
# master-cluster/flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    auth-api.url = "git+ssh://git@://github.com";
    payment-api.url = "git+ssh://git@://github.com";
  };

  outputs = { self, nixpkgs, auth-api, payment-api }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = pkgs.lib;

      # Simply reference the flake outputs directly
      allFlakes = [ auth-api payment-api ];

      # -------------------------------------------------------------
      # PHASE 1: Build Local (Nix Atomic Barrier)
      # -------------------------------------------------------------
      # Collect all container derivations. If one fails to compile, 
      # Nix will abort evaluation instantly before any bash code runs.
      containerList = map (f: f.packages.${system}.container) 
                        (builtins.filter (f: f.packages.${system} ? container) allFlakes);

      allContainers = pkgs.linkFarm "cluster-containers" (map (drv: {
        name = drv.imageName;
        path = drv;
      }) containerList);

      # Helper function to extract and join specific lifecycle hooks across all flakes
      getHooksFor = phase: lib.concatMapStringsSep "\n" 
        (f: f.lifecycleHooks.${phase} or "") allFlakes;

      # -------------------------------------------------------------
      # MASTER PIPELINE GENERATION
      # -------------------------------------------------------------
      deployScript = pkgs.writeShellScriptBin "cluster-deploy" ''
        set -e
        export REGISTRY="your-registry.com"

        echo "========================================="
        echo "PHASE 1: Verifying Atomic Nix Store Build"
        echo "========================================="
        # Forcing a reference to the linkFarm ensures Nix builds all containers first
        ls -d ${allContainers}/* > /dev/null
        echo "✔ All cluster containers successfully compiled."

        echo "========================================="
        echo "PHASE 2: Pre-Infrastructure Hooks"
        echo "========================================="
        ${getHooksFor "preInfra"}

        echo "========================================="
        echo "PHASE 3: Infrastructure Application"
        echo "========================================="
        ${getHooksFor "infraApply"}

        echo "========================================="
        echo "PHASE 4: Registry Push"
        echo "========================================="
        # We dynamically compute the tag using the Nix store hash of the container!
        ${lib.concatMapStringsSep "\n" (drv: ''
          # Parse the outPath (e.g. /nix/store/7xb9...-auth-api.tar.gz) to get the hash
          STORE_HASH=$(echo "${drv}" | cut -d'-' -f1 | rev | cut -d'/' -f1 | rev)
          IMAGE_NAME="${drv.imageName}"
          
          echo "Pushing $IMAGE_NAME with absolute tracking tag: $STORE_HASH"
          ${pkgs.skopeo}/bin/skopeo copy \
            nix-archive:${drv} \
            docker://$REGISTRY/$IMAGE_NAME:$STORE_HASH
        '') containerList}

        echo "========================================="
        echo "PHASE 5: Application Deployment (Kubenix)"
        echo "========================================="
        ${getHooksFor "appApply"}

        echo "========================================="
        echo "PHASE 6: Post-Deployment Verification"
        echo "========================================="
        ${getHooksFor "postDeploy"}

        echo "🚀 Staged deployment successfully executed!"
      '';
    in {
      apps.${system}.default = {
        type = "app";
        program = "${deployScript}/bin/cluster-deploy";
      };
    };
}

```

## Directory

## Useful Links

## Tags
