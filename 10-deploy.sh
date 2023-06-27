#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh

#download kubectl
if [[ ! -f ./kubectl ]]; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x kubectl
fi

./40-start-a-k8s-cluster.sh
sleep 60
if [[ ! -d ./istio-${ISTIO_VERSION}/ ]]; then
#  curl -L https://istio.io/downloadIstio | TARGET_ARCH=x86_64 sh -
curl -L https://istio.io/downloadIstio | ${ISTIO_VERSION} TARGET_ARCH=x86_64 sh -
fi

istioctl install \
  --set profile=default \
  --skip-confirmation

kubectl label namespace default istio-injection=enabled

kubectl apply -f manifest/deployment.yaml
kubectl apply -f manifest/service.yaml
kubectl apply -f manifest/ingress.yaml

echo waiting for deployment to get ready
kubectl wait --for=condition=ready --timeout=90s -ndefault pod -l app=echoserver

./50-test.sh
./60-kiali.sh
./70-ingresses.sh
#./80-bookinfo.sh
