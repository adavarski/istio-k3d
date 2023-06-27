#!/usr/bin/env bash

set -eu
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $BASEDIR

source functions.sh
source set-env.sh

#set -x
set +e

./k3d cluster delete $CLUSTER || true

mv kubeconfig kubeconfig.$RANDOM || true

