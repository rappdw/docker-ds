#!/usr/bin/env bash
set -e

WORKDIR=${WORKDIR:-"/workdir"}

# install the module mounted in $WORKDIR
if [ ! -z $SKIP_INSTALL ]; then
    if [ -e $WORKDIR/setup.py ]; then
        pip install -e $WORKDIR
    elif [ -e /home/jovyan/setup.py ]; then
        pip install -e /home/jovyan
    elif [ -e /home/jovyan/project/setup.py ]; then
        pip install -e /home/jovyan/project
    fi
fi

HOME=/home/jovyan
if [ -d "/home/jovyan/project" ]; then
    exec su -m - jovyan -c "cd /home/jovyan/project; $@"
else
    exec su -m - jovyan -c "cd /home/jovyan; $@"
fi
