# Clayton Stories VR-2141

## Abstract
What I want:
* Utilize k8s as much as possible.
* Allow dotnet builds to be incrementally rebuilt as best as possible.
* Should allow all other microservices to essentially do the same

## General daily update log
### 01_26_2026
#### Update for Jira
Goal: Development of a unified developer expeirience that is: operating system agnostic, deterministic, fully reproducable,
able to produce build artifacts for production. The final product will be a graphical interface that allows developers
to build as much as possible locally and select branches and commits for each project that is deployed locally. This
will allow developers to be able to run, build, and test their changes indepdenently or in parrallel with other changes.
A developer will also be able to share their current env with any other developer meaning.

Example: A developer provides a manifest that will build the same conditions that they have on anothers computer.

High level overview:
Flyway - For migrating local database instances
Minikube - Local K8s cluster to run and manage containers
Helm - For multi env service blue prints (charts) that can be used to deploy to different envs
Nix - For deterministic and reproducable container building that can pin to spcific branches, commits.
Zig - Runtime free systems logic for kjkjglue coding and process management and serve as backend to front end.
React - To build front end UI
DeterminateNix Gh actions

Process Walkthrough:
Nix Image Container builds spcific Nix flake into a fully verion pinned and reproducable docker image of a given repo.
-> Repeat for all Given repositories.
-> when all Repositories produce Cryptographically verified containers move to orchestration phase
-> Helm chart references build artifacts produced in the previous phase and allow env specific configuration
-> Helm Chart deploys requisit artifacts into their respective services in minikube pod.
-> All Process tracking handled by running zig process that acts as a glue between services and backend web server.
-> All Selection and status of the pod is propigated to the user via GUI interface written in web technologies.

Opinions and Reasons:
Containers while often sold as the golden hammer to every problem reveal a new level of problem that has traditionally
been handled by another team in the form of dev ops. As it solves the underlying problem it poses the problem that exists
just above it. Additionally containers while themselves are immutable the process in which that they are built through
technologies such as docker are not deterministic and are not reproducable, not in the literal sense of those terms.
Docker ultimately lacks the facilities to create a lock file that serves as a cryptogrphic signature the the accuracy
of inputs and outputs. More simply, the contianers can be guarenteed to work, but building them is not and differences
in build environments can produce Cryptographically different build artifacts. In order for a developer to truly leverage
the ability to develop ontop of containers building a container is the often overlooked component, and often results in
a registry of containers where this is no guarentee that they can be build in any env other than the one that they were
built in. It also creates a situation in which we have two sources of truth that may not actually reflect accurately
what is "the truth" our repository may list some branch or commit, but the other registry through a failure in CI/CD
environmental differences, or break in manual process, may list a container that doesn't reflect the current state of
that repository. With the blend of these technologies (namely Nix) we can construct fully reproducable and version pinned
containers, and the 'recipe' for doing such is always within the repository and through github action can verify on
every push and pull that everything is as it should be.

Packages that are not in github packages that need to be:

Need to get a hole of scms about these packages getting dual published.

Cmh.Vmf.Rmktg.Account.Api.Client 2.0.1.347
Cmh.Vmf.Rmktg.Account.Dto 2.0.1.347
Cmh.Vmf.Rmktg.Asset.Api.Client 2.0.1.1300
Cmh.Vmf.Rmktg.Asset.Dto 2.0.1.1300

### 01_16_2026
Switching gears here, going to try to have a docker contianer that has all of the env in it that then produces the
final image.

### 01_15_2026
Here is possibly the script I'm looking at doing:
Generate a deps.json file: Nix requires a lock file for dependencies to ensure reproducibility. You can generate this
using the nuget-to-nix tool or a similar script provided within the nixpkgs dotnet infrastructure.
Place your nuget.config file in the root directory of your project (or in a specified location).
Run dotnet restore with the configuration file specified, if needed: dotnet restore --configfile nuget.config.
Use nuget-to-nix or the fetch-deps script from buildDotnetModule's passthru to generate the dependency file (e.g.,
deps.json or deps.nix):

bash

nix-shell -p nuget-to-nix --run "nuget-to-nix packages > deps.nix"
# or use the fetch-deps script from your flake
This file will contain the URLs and hashes for all the required NuGet packages, including those from your custom
source in nuget.config.

Got it — you’re on **macOS**, and you want a **self‑contained NixOS container** that:

1.  **Imports your developer credentials**, specifically:
    *   NuGet config (e.g., `~/.nuget/NuGet/NuGet.Config`)
    *   Git credentials (token or SSH keys)
    *   SSL certificates (system + internal/corporate CAs)

2.  **Uses those credentials *inside the container*** so it can:
    *   restore private NuGet feeds
    *   clone private Git repositories
    *   fetch flakes over TLS using your internal CAs

3.  **Builds Nix flakes inside the container**

4.  **Exports build artifacts back to the macOS filesystem**

You want a clean “build sandbox” on macOS that acts like a credential‑aware CI runner.

Below is the **recommended architecture** and a **fully working setup**.

***

# ✅ Recommended Approach (macOS ➜ Linux container ➜ flake build)

On macOS, the simplest, fully working approach is:

1.  **Use a NixOS system container via Docker**
    (macOS cannot run NixOS containers natively — only Linux can)

2.  **Mount host credential files into the container**
    So you never bake secrets into the image.

3.  **Mount an output directory to get all build artifacts back**

4.  **Use `nix build` inside the container**
    With full access to your:
    *   NuGet feeds
    *   Git credentials
    *   SSL certificates

***

# 🐳 **1. Dockerfile: NixOS + CA Certs + tooling**

A minimal NixOS container with:

*   `cacert`
*   git + nix
*   dotnet-sdk (if you need NuGet restore before flake builds)
*   ability to read your mounted credentials

```Dockerfile
FROM nixos/nix:latest

# Install NixOS system packages
RUN nix-env -iA nixpkgs.git \
             nixpkgs.cacert \
             nixpkgs.curl \
             nixpkgs.dotnet-sdk-8_0

# Configure system-wide cert locations
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt
ENV SSL_CERT_DIR=/etc/ssl/certs
```

Build the image:

```sh
docker build -t nix-flake-builder .
```

***

# 🧩 **2. Run container with mounted credentials & output**

### Mac filesystem → Container (read‑only):

| Host File                     | Mount To                           | Purpose               |
| ----------------------------- | ---------------------------------- | --------------------- |
| `~/.nuget/NuGet/NuGet.Config` | `/root/.config/NuGet/NuGet.Config` | Private NuGet feeds   |
| `~/.gitconfig`                | `/root/.gitconfig`                 | Git identity settings |
| `~/.ssh/id_rsa`               | `/root/.ssh/id_rsa`                | SSH auth              |
| `~/my-certs.pem`              | `/etc/ssl/certs/my-certs.pem`      | Corporate CAs         |
| `/path/to/project`            | `/workspace`                       | Flake source          |
| `/path/to/output`             | `/out`                             | Build artifacts       |

Run:

```sh
docker run --rm -it \
  -v $HOME/.nuget/NuGet/NuGet.Config:/root/.config/NuGet/NuGet.Config:ro \
  -v $HOME/.gitconfig:/root/.gitconfig:ro \
  -v $HOME/.ssh:/root/.ssh:ro \
  -v /path/to/my-certs.pem:/etc/ssl/certs/my-certs.pem:ro \
  -v /path/to/flake:/workspace \
  -v /path/to/output:/out \
  nix-flake-builder bash
```

***

# 🔐 **3. Fix SSL inside container**

Inside the container:

```sh
cat /etc/ssl/certs/my-certs.pem >> /etc/ssl/certs/ca-bundle.crt
```

(Optional, or automate with Dockerfile if CA is not secret.)

Test:

```sh
curl https://your-internal-feed/
```

***

# ❄️ **4. Build flake inside container**

Inside the container:

```sh
cd /workspace
nix build .#yourPackage --out-link /out/result
```

Everything produced by the flake is now available on macOS under:

    /path/to/output/result

***

# 💡 Optional: create a `build.sh` on macOS

```sh
#!/bin/bash

docker run --rm \
  -v $HOME/.nuget/NuGet/NuGet.Config:/root/.config/NuGet/NuGet.Config:ro \
  -v $HOME/.gitconfig:/root/.gitconfig:ro \
  -v $HOME/.ssh:/root/.ssh:ro \
  -v /path/to/my-certs.pem:/etc/ssl/certs/my-certs.pem:ro \
  -v "$(pwd)":/workspace \
  -v "$(pwd)/build-out":/out \
  nix-flake-builder \
  nix build /workspace#defaultPackage --out-link /out/result
```

Now your secure, credential-aware flake builder is simply:

```sh
./build.sh
```

***

# 🎁 **If you want, I can also provide:**

✅ A version with **GitHub PAT** instead of SSH
✅ A version using **dotenv‑style secrets**
✅ A fully declarative NixOS flake to build the container image
✅ A system that automatically updates CA certs inside the container
✅ A version using **Colima** instead of Docker

Just tell me what you'd like added!


### 01_14_2026
Found how out how you actually build specific packages for distrution extrinsic to proget and nuget
dotnet pack

If you need access to Teamcity to look around at the build configs. Open a ticket at SCMSHD@claytonhomes.com and I'll
get your access added.


### 01_12_2026
#### Update for Jira
Goal: Development of a unified developer expeirience that is: operating system agnostic, deterministic, fully reproducable,
able to produce build artifacts for production. The final product will be a graphical interface that allows developers
to build as much as possible locally and select branches and commits for each project that is deployed locally. This
will allow developers to be able to run, build, and test their changes indepdenently or in parrallel with other changes.
A developer will also be able to share their current env with any other developer meaning.

Example: A developer provides a manifest that will build the same conditions that they have on anothers computer.

High level overview:
Flyway - For migrating local database instances
Minikube - Local K8s cluster to run and manage containers
Helm - For multi env service blue prints (charts) that can be used to deploy to different envs
Nix - For deterministic and reproducable container building that can pin to spcific branches, commits.
Zig - Runtime free systems logic for glue coding and process management and serve as backend to front end.
React - To build front end UI

Process Walkthrough:
Nix Image Container builds spcific Nix flake into a fully verion pinned and reproducable docker image of a given repo.
-> Repeat for all Given repositories.
-> when all Repositories produce Cryptographically verified containers move to orchestration phase
-> Helm chart references build artifacts produced in the previous phase and allow env specific configuration
-> Helm Chart deploys requisit artifacts into their respective services in minikube pod.
-> All Process tracking handled by running zig process that acts as a glue between services and backend web server.
-> All Selection and status of the pod is propigated to the user via GUI interface written in web technologies.

Opinions and Reasons:
Containers while often sold as the golden hammer to every problem reveal a new level of problem that has traditionally
been handled by another team in the form of dev ops. As it solves the underlying problem it poses the problem that exists
just above it. Additionally containers while themselves are immutable the process in which that they are built through
technologies such as docker are not deterministic and are not reproducable, not in the literal sense of those terms.
Docker ultimately lacks the facilities to create a lock file that serves as a cryptogrphic signature the the accuracy
of inputs and outputs. More simply, the contianers can be guarenteed to work, but building them is not and differences
in build environments can produce Cryptographically different build artifacts. In order for a developer to truly leverage
the ability to develop ontop of containers building a container is the often overlooked component, and often results in
a registry of containers where this is no guarentee that they can be build in any env other than the one that they were
built in. It also creates a situation in which we have two sources of truth that may not actually reflect accurately
what is "the truth" our repository may list some branch or commit, but the other registry through a failure in CI/CD
environmental differences, or break in manual process, may list a container that doesn't reflect the current state of
that repository. With the blend of these technologies (namely Nix) we can construct fully reproducable and version pinned
containers, and the 'recipe' for doing such is always within the repository and through github action can verify on
every push and pull that everything is as it should be.

## Legacy

### Install MiniKube
#### Macos
Follow the instructions on the page and select your kind of mac and install via brew [download](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download)

#### Windows

### Run minikube
```bash
minikube start
```
This should run and install a bunch of stuff

### check the minikube status
```bash
kubectl get PO -A
```
This command is very useful in seeing what you have running at this very moment

### Install Dashboard
run:
```bash
minikube dashboard
```
This will also run a nice web interface to check on the status of your single pod cluster

### Example Service
```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

### Create a deployment
this creates a new deployment
```bash
kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
```

You can either check the deployment via the webserver or the by issuing this command
```bash
kubectl get pods
```

```bash
kubectl expose deployment hello-minikube --type=NodePort --port=8080
```

Than check with:
```bash
kubectl get services hello-minikube
```

You can than let minikube open it for you in a web browser with:
```bash
minikube service hello-minikube
```

You can also have kubectl forward the port:
```bash
kubectl get services hello-minikube
```

### Load Balancer
```bash
kubectl create deployment balanced --image=kicbase/echo-service1:0
kubectl expose deployment balanced --type=LoadBalancer --port=8080
```

in another window run
```bash
minikube tunnel
```

To find the routable Ip run
```bash
kubectl get services
```
and under the loadbalancer you will see it now has an external IP

### Ingress
first enable the ingress addon
```bash
minikube addons enable ingress
```
NOTE: There maybe a firewall related issue here that may need to be resolved.

create a file with the following:
```yaml
kind: Pod
apiVersion: v1
metadata:
  name: foo-app
  labels:
    app: foo
spec:
  containers:
    - name: foo-app
      image: 'kicbase/echo-server:1.0'
---
kind: Service
apiVersion: v1
metadata:
  name: foo-service
spec:
  selector:
    app: foo
  ports:
    - port: 8080
---
kind: Pod
apiVersion: v1
metadata:
  name: bar-app
  labels:
    app: bar
spec:
  containers:
    - name: bar-app
      image: 'kicbase/echo-server:1.0'
---
kind: Service
apiVersion: v1
metadata:
  name: bar-service
spec:
  selector:
    app: bar
  ports:
    - port: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
    - http:
        paths:
          - pathType: Prefix
            path: /foo
            backend:
              service:
                name: foo-service
                port:
                  number: 8080
          - pathType: Prefix
            path: /bar
            backend:
              service:
                name: bar-service
                port:
                  number: 8080
---
```
See File 'ingressExample.yaml'

Than apply
```bash
kubectl apply -f ingressExample.yaml
```

In another terminal
```bash
sudo minikube tunnel
```

```bash
kubectl get ingress
```
Note for Docker Desktop Users:
To get ingress to work you’ll need to open a new terminal window and run minikube tunnel and in the following step use
127.0.0.1 in place of <ip_from_above>.

than to test:

It make take sometime for everything to actually deploy and work

```bash
curl http://127.0.0.1/foo
curl http://127.0.0.1/bar
```
## Thoughts

### Goal
We want an easy to user interface in which we can fully test as much as can locally where by building out a specific
dotnet package propigates changes to all dependencies in the cluster and redeploys them as well. We want to treat the
cluster as immutable as possible maybe utilizing nix where appropriate.

[[clayton-stories-vr-2141-nix-docker-example]]

This idea is going to mostly be that we are going to use nix to compose the docker file build step then we are going to
use a zig program to orchestrate each build where in the zig build system we are going to dispatch build commands that
will run the nix build commands that will actually produce the images that will then get loaded into docker and used
by k8s and minikube.

Nix with flakes:
Builds the images declaritively along with also allowing us to pin the inputs meaning we can actually quickly move back
and forth between verseions quickly as we can cache them. Also we can ensure that when we go to production that everything
matches.

k8s minikube:
For actually maintaining

### Mental walk through
Create a nix fkae that allows us to build a given dotnet docker image. Each flake produces a number of outputs that can
than be used by other flakes, for example each dotnet repo flake that produces an image will have that image available
but also will provide as part of it's outputs any client and dto objects that need to be made available to other packages

### Walk through 2
Nix will build the applicatoin and libraries using a flake that can reference specific brnahces or commits in repositories
that hold dependencies. They are going to be built intside of a runner that is a docker container that has the nixos
image as the base image. At the end what would be producesd is all of the things defined in the flake.

### I have finally gotten a docker image to build with nix
[[nix-package-manager-how-to-setup-remote-builder-for-mac]]
Now that I have been able to create a docker image in nix and am able to run it I need to back up and get my git creds
into the build env in a good and easy way. Than I need to test actually building the dotnet apps in there. I wonder
if it is at all possible to just try and build them right now? I guess lets try

### Working on the initial version of flaking a docker build script underway
Will need to get the digest of input images and nix hash see


## Directory
[[minikube-documentation]]

## Useful Links

## Tags
[[containers]]
[[docker]]
[[kubernetes]]
[[kubernetes-service]]
[[nexus-nix]]
[[skopeo]]
