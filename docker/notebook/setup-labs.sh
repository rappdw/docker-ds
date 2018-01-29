#!/usr/bin/env bash

. /home/jovyan/.venvs/notebook/bin/activate
echo "**** Installing any requirements ****"
pip install -r /tmp/requirements.txt
echo "**** enable jupyterlab ****"
jupyter serverextension enable --py jupyterlab
echo "**** install github extension ****"
jupyter labextension install @jupyterlab/github
echo "**** enable github extension ****"
jupyter serverextension enable --sys-prefix --py jupyterlab_github
echo "**** enable bokeh extension ****"
jupyter labextension install jupyterlab_bokeh