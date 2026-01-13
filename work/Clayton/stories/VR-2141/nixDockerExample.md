# Clayton Stories VR-2141 - Nix Docker Example

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

## Abstract
Here’s the **complete workflow** for building a deterministic image with Nix, loading it into Docker, and cleaning up containers/images afterward:

***

## ✅ Step 1: Publish the .NET app inside Nix (no prebuilt folder needed)

Add this to your `flake.nix` (or use the snippet from earlier):

```nix
svcXPublish = pkgs.stdenv.mkDerivation {
  pname = "publish-svcx";
  version = "1.2.3";
  src = ./src/SvcX;
  buildInputs = [ pkgs.dotnet-sdk_8 ];
  buildPhase = ''
    dotnet restore
    dotnet publish -c Release -o publish
  '';
  installPhase = ''
    mkdir -p $out
    cp -r publish/* $out/
  '';
};

packages.svcxImage = pkgs.dockerTools.buildImage {
  name = "svc-x";
  tag = "1.2.3";
  contents = [ pkgs.dotnet-runtime_8 svcXPublish ];
  config.Cmd = [ "dotnet" "SvcX.dll" ];
  config.ExposedPorts = [ "8080" ];
};
```

***

## ✅ Step 2: Build the image tarball with Nix

Run:

```bash
nix build .#svcXImage
```

This creates a symlink called `result` pointing to the tarball in the Nix store (e.g., `/nix/store/abc123-svc-x-1.2.3.tar`).

To see the actual path:

```bash
nix build .#svcXImage --print-out-paths
```

***

## ✅ Step 3: Load the image into Docker

```bash
docker load -i result
```

After loading, check:

```bash
docker images | grep svc-x
```

You should see:

    svc-x    1.2.3    <IMAGE_ID>

***

## ✅ Step 4: Run the container locally

```bash
docker run --rm -p 8080:8080 svc-x:1.2.3
```

*   `--rm` removes the container after it exits.
*   `-p 8080:8080` maps the container port to your host.

***

## ✅ Step 5: Retag and push to your registry (ProGet)

```bash
docker tag svc-x:1.2.3 proget.local.test:5000/mycompany/svcx:1.2.3
docker push proget.local.test:5000/mycompany/svcx:1.2.3
```

Login first if needed:

```bash
docker login proget.local.test:5000
```

***

## ✅ Step 6: Deploy to Kubernetes

```bash
helm upgrade --install svcx ./charts/svcx \
  --set image.repository=proget.local.test:5000/mycompany/svcx \
  --set image.tag=1.2.3
```

***

## ✅ Step 7: Remove all containers and images built with this

### Remove all running containers:

```bash
docker ps -q | xargs -r docker stop
```

### Remove all containers (including stopped):

```bash
docker ps -aq | xargs -r docker rm
```

### Remove the image `svc-x:1.2.3`:

```bash
docker rmi svc-x:1.2.3
```

### Remove all dangling images (optional cleanup):

```bash
docker image prune -f
```

### Remove all images (⚠️ destructive):

```bash
docker images -q | xargs -r docker rmi -f
```

***

## ✅ Quick Summary of Commands

```bash
# Build image tarball
nix build .#svcXImage

# Load into Docker
docker load -i result

# Verify
docker images | grep svc-x

# Run locally
docker run --rm -p 8080:8080 svc-x:1.2.3

# Retag and push
docker tag svc-x:1.2.3 proget.local.test:5000/mycompany/svcx:1.2.3
docker push proget.local.test:5000/mycompany/svcx:1.2.3

# Cleanup
docker ps -aq | xargs -r docker rm
docker rmi svc-x:1.2.3
docker image prune -f
```

***

👉 Do you want me to **extend this flake** so you can run a single command like:

```bash
nix run .#pushSvcX
```

to **build, load, retag, and push automatically**?
Or should I also include **commands for kind/minikube image loading** for local clusters?


## Directory

## Useful Links

## Tags
