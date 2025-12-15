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

## Directory
[[minikube-documentation]]

## Useful Links

## Tags
[[containers]]
[[docker]]
[[kubernetes]]
[[kubernetes-service]]
