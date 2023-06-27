#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh




kubectl apply -f ./istio-${ISTIO_VERSION}/samples/bookinfo/platform/kube/bookinfo.yaml


kubectl wait --for=condition=ready --timeout=90s -ndefault pod -l app=ratings
kubectl wait --for=condition=ready --timeout=90s -ndefault pod -l app=details

kubectl exec "$(kubectl get pod -l app=ratings \
  -o jsonpath='{.items[0].metadata.name}')" \
  -c ratings \
  -- curl -sS productpage:9080/productpage \
  | grep -o "<title>.*</title>"

