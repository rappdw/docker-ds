#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

if [ -e /home/jovyan/project/notebooks ]; then
    # for any notebooks in the 'notebooks' sub-dir, sign them, we will "trust" them
    pushd /home/jovyan/project/notebooks
    for f in *.ipynb; do
        jupyter trust "$f"
    done
    popd
fi

# determine if we are running lab or notebook
NOTEBOOK_MODE=${NOTEBOOK_MODE:-notebook}

if [[ ! -z "${JUPYTERHUB_API_TOKEN}" ]]; then
  # launched by JupyterHub, use single-user entrypoint
  exec /usr/local/bin/start-singleuser.sh $*
else
  . /usr/local/bin/start.sh jupyter $NOTEBOOK_MODE $*
fi
