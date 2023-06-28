## istio-k3d (POC)

This POC performs a istio installation in a k3d cluster.

### Usage
```
./istio-k3d-POC/10-deploy.sh
```

### Check: 

```
$ kubectl get po
NAME                            READY   STATUS    RESTARTS   AGE
echoserver-v1-77d4665d6-5562w   2/2     Running   0          9m
echoserver-v1-77d4665d6-9lxc7   2/2     Running   0          9m
echoserver-v1-77d4665d6-4tpgz   2/2     Running   0          9m

$ kubectl get po -n istio-system
NAME                                  READY   STATUS    RESTARTS   AGE
istiod-5855798659-rhsmp               1/1     Running   0          10m
istio-ingressgateway-d898789f-9j8cq   1/1     Running   0          9m51s
jaeger-76cd7c7566-5lcpr               1/1     Running   0          8m4s
kiali-7799445c94-wbjwp                1/1     Running   0          8m5s
prometheus-67599c8d5c-9rl56           2/2     Running   0          8m4s
grafana-5f98b97b64-5945f              1/1     Running   0          8m3s

$ kubectl get svc -n istio-system
NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                      AGE
istiod                 ClusterIP      10.43.21.181    <none>        15010/TCP,15012/TCP,443/TCP,15014/TCP        31m
istio-ingressgateway   LoadBalancer   10.43.175.152   172.28.0.2    15021:30368/TCP,80:31424/TCP,443:32240/TCP   31m
kiali                  ClusterIP      10.43.88.5      <none>        20001/TCP,9090/TCP                           29m
tracing                ClusterIP      10.43.163.81    <none>        80/TCP,16685/TCP                             29m
zipkin                 ClusterIP      10.43.154.225   <none>        9411/TCP                                     29m
jaeger-collector       ClusterIP      10.43.95.181    <none>        14268/TCP,14250/TCP,9411/TCP                 29m
prometheus             ClusterIP      10.43.123.151   <none>        9090/TCP                                     29m
grafana                ClusterIP      10.43.137.85    <none>        3000/TCP                                     29m


$ kubectl get ing -n istio-system
NAME      CLASS    HOSTS                         ADDRESS      PORTS   AGE
grafana   <none>   grafana.192.168.1.99.nip.io   172.28.0.2   80      25m
kiali     <none>   kiali.192.168.1.99.nip.io     172.28.0.2   80      25m
prom      <none>   prom.192.168.1.99.nip.io      172.28.0.2   80      25m
tracing   <none>   tracing.192.168.1.99.nip.io   172.28.0.2   80      11m
```

### Browser:

- Kiali: http://kiali.192.168.1.99.nip.io:8080
- Prometheus: http://prom.192.168.1.99.nip.io:8080
- Grafana: http://grafana.192.168.1.99.nip.io:8080
- Jaeger: http://tracing.192.168.1.99.nip.io:8080


### Screenshots:

Kiali:

istio-system: 
<img src="screenshots/k3d-istio-kiali.png?raw=true" width="1000">

Bookinfo: 
<img src="screenshots/k3d-istio-bookinfo.png?raw=true" width="1000">

Prometheus:

<img src="screenshots/k3d-istio-prometheus.png?raw=true" width="1000">

Grafana:

<img src="screenshots/k3d-istio-grafana.png?raw=true" width="1000">

Jaeger (Tracing):

<img src="screenshots/k3d-istio-jaeger.png?raw=true" width="1000">


### Bookinfo 
```
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -s productpage:9080/productpage | grep -o "<title>.*</title>"
kubectl apply -f istio-1.18.0/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get gateway
istioctl analyze

kubectl get svc istio-ingressgateway -n istio-system
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o jsonpath='{.items[0].status.hostIP}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "$GATEWAY_URL"

echo "http://$GATEWAY_URL/productpage"

kubectl apply -f istio-1.18.0/samples/bookinfo/networking/destination-rule-all.yaml
kubectl get destinationrules -o yaml


cleanup: bookinfo
istio-1.18.0/samples/bookinfo/platform/kube/cleanup.sh
kubectl get virtualservices   #-- there should be no virtual services
kubectl get destinationrules  #-- there should be no destination rules
kubectl get gateway           #-- there should be no gateway
kubectl get pods              #-- the Bookinfo pods should be deleted
```
### google-samples-microservices 

Ref:https://github.com/GoogleCloudPlatform/microservices-demo

```

$ kubectl create ns google-samples-microservices

$ kubectl apply -n google-samples-microservices -f google-samples-microservices/kubernetes-manifests.yaml

$ kubectl get pod -n google-samples-microservices
NAME                                     READY   STATUS    RESTARTS   AGE
svclb-frontend-external-2sg5q            0/1     Pending   0          2m57s
svclb-frontend-external-9rfq4            0/1     Pending   0          2m57s
checkoutservice-558b447fdc-9dnmx         1/1     Running   0          2m58s
shippingservice-7b64ffc765-kvzfv         1/1     Running   0          2m55s
redis-cart-78746d49dc-wbrhm              1/1     Running   0          2m55s
productcatalogservice-cc7c79cf5-b4wlp    1/1     Running   0          2m56s
frontend-8446f74795-8nghz                1/1     Running   0          2m57s
cartservice-d7f69f549-jckfq              1/1     Running   0          2m56s
currencyservice-7d5c4974b9-p5sz7         1/1     Running   0          2m56s
paymentservice-6fd9ff5d6c-tg4cx          1/1     Running   0          2m57s
loadgenerator-d95bc946f-j562g            1/1     Running   0          2m56s
emailservice-f57d5c6c9-lm6xv             1/1     Running   0          2m58s
recommendationservice-79fd4d769c-dd6bc   1/1     Running   0          2m58s
adservice-65d4dc6b67-pmth7               1/1     Running   0          2m55s

$ kubectl get svc -n google-samples-microservices
NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
emailservice            ClusterIP      10.43.182.252   <none>        5000/TCP       3m
checkoutservice         ClusterIP      10.43.122.110   <none>        5050/TCP       3m
recommendationservice   ClusterIP      10.43.150.235   <none>        8080/TCP       3m
frontend                ClusterIP      10.43.198.168   <none>        80/TCP         2m59s
frontend-external       LoadBalancer   10.43.237.62    <pending>     80:30841/TCP   2m59s
paymentservice          ClusterIP      10.43.200.157   <none>        50051/TCP      2m59s
productcatalogservice   ClusterIP      10.43.194.205   <none>        3550/TCP       2m58s
cartservice             ClusterIP      10.43.218.17    <none>        7070/TCP       2m58s
currencyservice         ClusterIP      10.43.223.195   <none>        7000/TCP       2m57s
shippingservice         ClusterIP      10.43.129.253   <none>        50051/TCP      2m57s
redis-cart              ClusterIP      10.43.156.117   <none>        6379/TCP       2m57s
adservice               ClusterIP      10.43.155.192   <none>        9555/TCP       2m57s

http://192.168.56.101:30841

kubectl create ns istio-app
kubectl label ns istio-app istio-injection=enabled
kubectl apply -n istio-app -f google-samples-microservices/kubernetes-manifests.yaml
kubectl get pod -n istio-app
kubectl delete svc frontend-external -n istio-app
kubectl get svc -n istio-system
kubectl apply -n istio-app -f google-samples-microservices/istio-manifests.yaml
kubectl delete serviceentry allow-egress-google-metadata -n istio-app
kubectl delete serviceentry allow-egress-googleapis -n istio-app
http://192.168.56.101:30792 kubectl get svc -n istio-system

istio
kubectl delete deploy productcatalogservice -n istio-app

productcatalog-v1.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: productcatalogservice-v1
spec:
  selector:
    matchLabels:
      app: productcatalogservice
  template:
    metadata:
      labels:
        app: productcatalogservice
        version: v1
    spec:
      serviceAccountName: default
      terminationGracePeriodSeconds: 5
      containers:
      - name: server
        image: docker.io/v5cn/google-samples-microservices-productcatalogservice:v0.3.6
        ports:
        - containerPort: 3550
        env:
        - name: PORT
          value: "3550"
        - name: DISABLE_STATS
          value: "1"
        - name: DISABLE_TRACING
          value: "1"
        - name: DISABLE_PROFILER
          value: "1"
        readinessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:3550"]
        livenessProbe:
          exec:
            command: ["/bin/grpc_health_probe", "-addr=:3550"]
        resources:
          requests:
            cpu: 100m
            memory: 64Mi
          limits:
            cpu: 200m
            memory: 128Mi

kubectl apply -n istio-app -f productcatalog-v1.yaml
kubectl get deploy productcatalogservice-v1 -n istio-app

productcatalog-v2.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: productcatalogservice-v2
spec:
  selector:
    matchLabels:
      app: productcatalogservice
  template:
    metadata:
      labels:
        app: productcatalogservice
        version: v2
    spec:
      containers:
      - env:
        - name: PORT
          value: '3550'
        - name: EXTRA_LATENCY
          value: 3s
        image: docker.io/v5cn/google-samples-microservices-productcatalogservice:v0.3.6
        livenessProbe:
          exec:
            command:
            - /bin/grpc_health_probe
            - -addr=:3550
        name: server
        ports:
        - containerPort: 3550
        readinessProbe:
          exec:
            command:
            - /bin/grpc_health_probe
            - -addr=:3550
        resources:
          limits:
            cpu: 200m
            memory: 128Mi
          requests:
            cpu: 100m
            memory: 64Mi
      terminationGracePeriodSeconds: 5
      
kubectl apply -n istio-app -f productcatalog-v2.yaml
kubectl get deploy productcatalogservice-v2 -n istio-app

vs-split-traffic.yaml

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: productcatalogservice
spec:
  hosts:
  - productcatalogservice
  http:
  - route:
    - destination:
        host: productcatalogservice
        subset: v1
      weight: 75
    - destination:
        host: productcatalogservice
        subset: v2
      weight: 25

kubectl apply -n istio-app -f vs-split-traffic.yaml

destinationrule.yaml

apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: productcatalogservice
spec:
  host: productcatalogservice
  subsets:
    - labels:
        app: productcatalogservice
        version: v1
      name: v1
    - labels:
        app: productcatalogservice
        version: v2
      name: v2

kubectl apply -n istio-app -f destinationrule.yaml
```
