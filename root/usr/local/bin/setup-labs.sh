#!/usr/bin/env bash

echo "**** enable jupyterlab ****"
jupyter serverextension enable --py jupyterlab
#echo "**** enable github extension ****"
#jupyter serverextension enable --sys-prefix --py jupyterlab_github
echo "**** setup lab extensions (matplotlib, bokeh, plotly, etc.) ****"
jupyter labextension install @jupyter-widgets/jupyterlab-manager jupyter-matplotlib jupyterlab_bokeh @pyviz/jupyterlab_holoviews @jupyterlab/plotly-extension qgrid @jpmorganchase/perspective-jupyterlab pylantern
#echo "**** install github extension ****"
#jupyter labextension install @jupyterlab/github
#echo "**** setup collaboration via Google Drive ****"
#jupyter labextension install @jupyterlab/google-drive
