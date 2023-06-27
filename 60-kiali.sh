#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh




kubectl apply -f ./istio-${ISTIO_VERSION}/samples/addons/kiali.yaml
kubectl apply -f ./istio-${ISTIO_VERSION}/samples/addons/jaeger.yaml
kubectl apply -f ./istio-${ISTIO_VERSION}/samples/addons/prometheus.yaml
kubectl apply -f ./istio-${ISTIO_VERSION}/samples/addons/grafana.yaml

kubectl wait --for=condition=ready --timeout=240s -nistio-system pod -l app=grafana
kubectl wait --for=condition=ready --timeout=240s -nistio-system pod -l app=prometheus
kubectl wait --for=condition=ready --timeout=240s -nistio-system pod -l app=jaeger
kubectl wait --for=condition=ready --timeout=240s -nistio-system pod -l app=kiali

istioctl dashboard kiali &
