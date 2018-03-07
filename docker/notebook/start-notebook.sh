#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# determine if we are running lab or notebook
NOTEBOOK_MODE=${NOTEBOOK_MODE:-notebook}
# determine if we are running CPU or GPU
CPU_GPU_ENV=${CPU_GPU_ENV:-"/cpu-env"}
. $CPU_GPU_ENV

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
  # launched by JupyterHub, use single-user entrypoint
  exec /usr/local/bin/start-singleuser.sh $*
else
  . /usr/local/bin/start.sh jupyter $NOTEBOOK_MODE $*
fi
