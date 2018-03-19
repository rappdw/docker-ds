#!/usr/bin/env bash

# assumes that the project has been mounted into /home/jovyan/project

CPU_GPU_ENV=${CPU_GPU_ENV:-"/cpu-env"}
. $CPU_GPU_ENV

if [ -e /home/jovyan/project/setup.py ]
then
    # install an editable version of the ner module into site-packages
    pip install -e /home/jovyan/project/
fi

if [ -e /home/jovyan/project/notebooks ]
then
    # for any notebooks in the 'notebooks' sub-dir, sign them, we will "trust" them
    pushd /home/jovyan/project/notebooks
    for f in *.ipynb; do
        jupyter trust "$f"
    done
    popd
fi

exec start-notebook.sh
