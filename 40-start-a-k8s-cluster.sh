#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source ./functions.sh
source ./set-env.sh


#install k3d
if [[ ! -f ./k3d ]]; then
  export K3D_INSTALL_DIR=${BASEDIR:-$(pwd)}
  export USE_SUDO='false'
  export PATH=$PATH:${BASEDIR} # k3d install fails otherwise
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v${K3D_VERSION} bash
fi


  if ! cluster-exists $CLUSTER; then


     k3d cluster create $CLUSTER  --k3s-arg "--disable=traefik@server:0" \
       --port 9443:443@loadbalancer \
       --port 8080:80@loadbalancer \
       --api-port 6443 \
       --wait 

#    k3d cluster create bob --servers 1 --agents 3 \
#      --port 9443:443@loadbalancer \
#      --port 80:80@loadbalancer \
#      --port '32036:32036@server[0]' \
#      --api-port 6443 \
#      --k3s-arg "--no-deploy=traefik@server:*" \


#    ./k3d cluster create $CLUSTER \
#      --wait 

#     --config k3d-config/$cluster.yaml \

  fi

# create endpoint in cluster pointing to my primary IP address
#kubectl apply -f manifest/namespace.yaml

#  export PRIMARY_IP=$(get-primary-ip)
#  envsubst < manifest/external-service.yaml.tpl | kubectl apply -nkafka -f -



#echo "waiting for metrics server pod to get ready"
#kubectl wait --for=condition=ready --timeout=90s -nkube-system pod -l k8s-app=metrics-server
