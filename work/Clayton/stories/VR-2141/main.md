# Clayton Stories VR-2141

## Abstract
What I want:
* Utilize k8s as much as possible.
* Allow dotnet builds to be incrementally rebuilt as best as possible.
* Should allow all other microservices to essentially do the same

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



## Directory
[[minikube-documentation]]

## Useful Links

## Tags
[[containers]]
[[docker]]
[[kubernetes]]
[[kubernetes-service]]
