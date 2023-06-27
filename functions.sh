#!/usr/bin/env bash

function ks() {
  kubectl get $(kubectl api-resources | grep -i strimzi | cut -d' ' -f1 | tr '\n' ',' | sed 's/,$//g') -A;
}
export -f ks

get-primary-ip() {
  local PRIMARY_IP=$(hostname -I | cut -d " " -f1)
  printf ${PRIMARY_IP}
}

function cluster-exists() {
  local cluster_name=$1
  #local K3D=$(get-k3d-path)
  local K3D=${BASEDIR}/k3d

  # need a blank after name. Else prefix would work, too.
  COUNT=$(${K3D} cluster list | grep ^${cluster_name}\  | wc -l)
  if [[ $COUNT -eq 0 ]]; then
    # 1 = false
    return 1
  else
    # 0 = true
    return 0 
  fi
}

export -f cluster-exists

