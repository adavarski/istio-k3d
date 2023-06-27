# istio-k3d POC

This POC performs a istio installation in a k3d cluster.

# Usage
```
git clone -o github https://github.com/adavarski/istio-k3d.git
./istio-k3d-POC/10-deploy.sh
```

Check: 

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

Browser:

- Kiali: http://kiali.192.168.1.99.nip.io:8080
- Prometheus: http://prom.192.168.1.99.nip.io:8080
- Grafana: http://grafana.192.168.1.99.nip.io:8080
- Jaeger: http://tracing.192.168.1.99.nip.io:8080


Screenshots:

<img src="screenshots/k3d-istio-kiali.png?raw=true" width="1000">

<img src="screenshots/k3d-istio-prometheus.png?raw=true" width="1000">

<img src="screenshots/k3d-istio-grafana.png?raw=true" width="1000">

<img src="screenshots/k3d-istio-jaeger.png?raw=true" width="1000">

