#!/usr/bin/env bash
set -e

WORKDIR=${WORKDIR:-"/workdir"}

# install the module mounted in $WORKDIR
if [ -e $WORKDIR/setup.py ]; then
    pip install -e $WORKDIR
elif [ -e $WORKDIR/requirements.txt ]; then
    pip install -r $WORKDIR/requirements.txt
elif [ -e /home/jovyan/setup.py ]; then
    pip install -e /home/jovyan
elif [ -e /home/jovyan/requirements.txt ]; then
    pip install -r /home/jovyan/requirements.txt
elif [ -e /home/jovyan/project/setup.py ]; then
    pip install -e /home/jovyan/project
elif [ -e /home/jovyan/project/requirements.txt ]; then
    pip install -r /home/jovyan/project/requirements.txt
fi

HOME=/home/jovyan
ESCAPED_ARGS=$(printf "%q " "$@")
if [ -d "/home/jovyan/project" ]; then
    exec su -m jovyan -c "cd /home/jovyan/project; $ESCAPED_ARGS"
else
    exec su -m jovyan -c "cd /home/jovyan; $ESCAPED_ARGS"
fi
