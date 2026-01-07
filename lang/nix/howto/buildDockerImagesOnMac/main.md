# Nix Lang How To - Build Docker Images On Mac

## Abstract
Need to test this from copilot:

Yes, you can absolutely use a **Linux builder inside Docker** to build Nix derivations (including `dockerTools.buildImage`) from macOS. This is a common workaround for Darwin limitations.

Here’s how it works:

***

### ✅ Why it works

*   Nix builds are sandboxed and expect Linux kernel features for `dockerTools`.
*   If you run a **Linux container with Nix installed**, you can delegate builds to it via Nix’s **remote builder protocol**.
*   macOS acts as the client; the Docker container acts as the builder.

***

### ✅ Setup Steps

#### 1. Start a Linux container with Nix

```bash
docker run --privileged -d \
  --name nix-builder \
  nixos/nix:latest \
  sleep infinity
```

(`--privileged` is needed for sandboxing and mounting.)

#### 2. Enable SSH inside the container

Install `openssh` and start the SSH daemon:

```bash
docker exec -it nix-builder bash
nix-env -iA nixpkgs.openssh
service ssh start
passwd root  # set a password or use keys
```

#### 3. Configure macOS Nix to use the container as a builder

Edit `/etc/nix/machines` on macOS:

    root@<container-ip> x86_64-linux - - 1

Or use `--builders` flag:

```bash
nix build .#svcXImage --builders 'ssh://root@<container-ip> x86_64-linux'
```

#### 4. Test

```bash
nix show-derivation .#svcXImage
nix build .#svcXImage
```

The build runs inside the Linux container and produces the Docker image tarball.

***

### ✅ Pros

*   No need for a full VM (lighter than Colima/Lima).
*   Works with `dockerTools` because the builder is Linux.
*   Reproducible and integrates with flakes.

### ✅ Cons

*   Requires SSH setup inside the container.
*   Performance depends on Docker’s filesystem and networking.

***

### ✅ Alternative: Use `nix build --impure` inside the container

Instead of remote builder, you can:

```bash
docker exec -it nix-builder bash
nix build .#svcXImage
```

Then copy the result tarball out:

```bash
docker cp nix-builder:/path/to/result ./result
```

***

Do you want me to **write a full script that spins up a Docker-based Nix builder and configures your macOS Nix to use it automatically**? Or **create a flake that includes a helper app to build via Docker and load into Minikube in one command**?


## Directory

## Useful Links

## Tags
