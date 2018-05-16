#!/usr/bin/env ash
set -e

WORKDIR=${WORKDIR:-"/workdir"}

# install the module mounted in $WORKDIR
if [ -e $WORKDIR/setup.py ]; then
    pip install -e $WORKDIR
fi

exec su - jovyan "$@"
