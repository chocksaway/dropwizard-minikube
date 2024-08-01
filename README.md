# Simple dropwizard app

How to start the Hello application
---

1. Run `mvn clean install` to build your application
1. Start application with `java -jar target/tester-1.0-SNAPSHOT.jar server config.yml`
1. To check that your application is running enter url `http://localhost:8080`

Health Check
---

To see your applications health enter url `http://localhost:8081/healthcheck`

#### Kubernetes

https://blog.devgenius.io/deploying-dropwizard-docker-image-into-minikube-cluster-59beb367685e

https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download

https://linuxhandbook.com/docker-permission-denied/

Install kubectl, minikube and docker

```
$ minikube start --driver=docker
😄  minikube v1.33.1 on Ubuntu 22.04
✨  Using the docker driver based on user configuration
📌  Using Docker driver with root privileges
👍  Starting "minikube" primary control-plane node in "minikube" cluster
🚜  Pulling base image v0.0.44 ...
💾  Downloading Kubernetes v1.30.0 preload ...
    > preloaded-images-k8s-v18-v1...:  342.90 MiB / 342.90 MiB  100.00% 1.40 Mi
    > gcr.io/k8s-minikube/kicbase...:  481.58 MiB / 481.58 MiB  100.00% 1.67 Mi
🔥  Creating docker container (CPUs=2, Memory=7900MB) ...
🐳  Preparing Kubernetes v1.30.0 on Docker 26.1.1 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
🔎  Verifying Kubernetes components...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
💡  kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

Maven package

```
mvn package

[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  3.283 s
[INFO] Finished at: 2024-08-01T19:47:20+01:00
[INFO] ------------------------------------------------------------------------


$ ls -ltr target/

tester-1.0-SNAPSHOT.jar
```

Build docker image

```
$ docker build -t hello:0.1.0 .
Sending build context to Docker daemon  38.02MB
Step 1/5 : FROM openjdk:21
 ---> 079114de2be1
Step 2/5 : EXPOSE 8080 8081
 ---> Using cache
 ---> 7cd7760a9e0e
Step 3/5 : COPY target/tester-1.0-SNAPSHOT.jar  tester-1.0-SNAPSHOT.jar
 ---> Using cache
 ---> 02489db8a175
Step 4/5 : COPY config.yml config.yml
 ---> Using cache
 ---> b4a98013e982
Step 5/5 : ENTRYPOINT ["java","-jar","tester-1.0-SNAPSHOT.jar","server","config.yml"]
 ---> Using cache
 ---> 46ce1e8b99b2
Successfully built 46ce1e8b99b2
Successfully tagged hello:0.1.0
```

Apply kubernetes application-config.yml

```
$ kubectl apply -f application-config.yml
configmap/application-config created
```

Apply kubernetes application-deployment.yml

```
$ kubectl apply -f application-deployment.yml
deployment.apps/hello created
service/hello created
```


minikube dashboard
```
$ minikube dashboard
🔌  Enabling dashboard ...
    ▪ Using image docker.io/kubernetesui/metrics-scraper:v1.0.8
    ▪ Using image docker.io/kubernetesui/dashboard:v2.7.0
💡  Some dashboard features require the metrics-server addon. To enable all features please run:

        minikube addons enable metrics-server

🤔  Verifying dashboard health ...
🚀  Launching proxy ...
🤔  Verifying proxy health ...


```
![dashboard.png](src/main/resources/assets/dashboard.png)

![dashboard.png](src/main/resources/assets/pods.png)

If you see the error 
```
Container image "hello:0.1.0" is not present with pull policy of Never
Error: ErrImageNeverPull

Run the following command:

eval $(minikube docker-env)

*Rebuild* the docker image.
```


```
$ kubectl get pods -l app=hello -o yaml |grep containerPort
- containerPort: 8080
- containerPort: 8081

$ kubectl get pods
NAME                     READY   STATUS    RESTARTS      AGE
hello-7546b7f4fb-zhf66   1/1     Running   1 (18m ago)   8d


$ kubectl port-forward hello-7546b7f4fb-zhf66 8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080

```

Point your web browser at http://127.0.0.1:8080?name=milesd



![dashboard.png](src/main/resources/assets/8080.png)

You will see the port redirection:
```
Handling connection for 8080
```
