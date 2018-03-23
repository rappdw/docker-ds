#!/usr/bin/env bash

echo "**** enable jupyterlab ****"
jupyter serverextension enable --py jupyterlab
echo "**** install github extension ****"
jupyter labextension install @jupyterlab/github
echo "**** enable github extension ****"
jupyter serverextension enable --sys-prefix --py jupyterlab_github
echo "**** enable bokeh extension ****"
jupyter labextension install jupyterlab_bokeh
echo "**** setup collaboration via Google Drive ****"
jupyter labextension install @jupyterlab/google-drive
echo "**** setup interaactive matplotlib ****"
jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-matplotlib
