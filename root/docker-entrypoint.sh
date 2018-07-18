#!/usr/bin/env bash
set -e

WORKDIR=${WORKDIR:-"/workdir"}

# install the module mounted in $WORKDIR
if [ -e $WORKDIR/setup.py ]; then
    pip install -e $WORKDIR
elif [ -e /home/jovyan/setup.py ]; then
    pip install -e /home/jovyan
elif [ -e /home/jovyan/project/setup.py ]; then
    pip install -e /home/jovyan/project
fi

exec su - jovyan "$@"
