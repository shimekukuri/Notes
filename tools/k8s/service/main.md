# Kubernetes - Service

## Abstract

### Documentation Definition
In Kubernetes, a Service is a method for exposing a network application that is running as one or more Pods in your
cluster.

A key aim of Services in Kubernetes is that you don't need to modify your existing application to use an unfamiliar
service discovery mechanism. You can run code in Pods, whether this is a code designed for a cloud-native world, or an
older app you've containerized. You use a Service to make that set of Pods available on the network so that clients
can interact with it.

If you use a Deployment to run your app, that Deployment can create and destroy Pods dynamically. From one moment to
the next, you don't know how many of those Pods are working and healthy; you might not even know what those healthy
Pods are named. Kubernetes Pods are created and destroyed to match the desired state of your cluster. Pods are
ephemeral resources (you should not expect that an individual Pod is reliable and durable).

Each Pod gets its own IP address (Kubernetes expects network plugins to ensure this). For a given Deployment in your
cluster, the set of Pods running in one moment in time could be different from the set of Pods running that
application a moment later.

This leads to a problem: if some set of Pods (call them "backends") provides functionality to other Pods (call them
"frontends") inside your cluster, how do the frontends find out and keep track of which IP address to connect to, so
that the frontend can use the backend part of the workload?

Enter Services.

The Service API, part of Kubernetes, is an abstraction to help you expose groups of Pods over a network. Each Service
object defines a logical set of endpoints (usually these endpoints are Pods) along with a policy about how to make
those pods accessible.

### Defining a Service

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

### Defining a service without a selector
Services most commonly abstract access to Kubernetes Pods thanks to the selector, but when used with a corresponding
set of EndpointSlices objects and without a selector, the Service can abstract other kinds of backends, including ones
that run outside the cluster.

For example:

- You want to have an external database cluster in production, but in your test environment you use your own databases.
- You want to point your Service to a Service in a different Namespace or on another cluster.
- You are migrating a workload to Kubernetes. While evaluating the approach, you run only a portion of your backends
in Kubernetes.

In any of these scenarios you can define a Service without specifying a selector to match Pods. For example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
```

Because this Service has no selector, the corresponding EndpointSlice objects are not created automatically. You can
map the Service to the network address and port where it's running, by adding an EndpointSlice object manually. For
example:

```yaml
apiVersion: discovery.k8s.io/v1
kind: EndpointSlice
metadata:
  name: my-service-1 # by convention, use the name of the Service
                     # as a prefix for the name of the EndpointSlice
  labels:
    # You should set the "kubernetes.io/service-name" label.
    # Set its value to match the name of the Service
    kubernetes.io/service-name: my-service
addressType: IPv4
ports:
  - name: http # should match with the name of the service port defined above
    appProtocol: http
    protocol: TCP
    port: 9376
endpoints:
  - addresses:
      - "10.4.5.6"
  - addresses:
      - "10.1.2.3"
```

## Directory

## Useful Links
[Kubernetes Service Doc](https://kubernetes.io/docs/concepts/services-networking/service/)

## Tags
