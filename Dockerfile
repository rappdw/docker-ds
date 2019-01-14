FROM continuumio/miniconda3

RUN set -ex; \
    apt-get update -y; \
    apt-get install -y \
        libasound2 \
        libgconf-2-4 \
        libgtk2.0-0 \
        libnss3 \
        libxtst6 \
        libxss1 \
        sudo \
        xvfb \
    ; \
    conda update -n base conda; \
    conda install \
        bokeh \
        cython \
        graphviz \
        holoviews \
        ipywidgets \
        jupyter \
        jupyterlab \
        networkx \
        nodejs \
        numpy \
        matplotlib \
        pandas \
        plotly \
        psutil \
        psycopg2 \
        scipy \
        scikit-learn \
        seaborn \
        sympy \
    ; \
    conda install -c plotly plotly-orca; \
    printf '#!/bin/bash \nxvfb-run -a /opt/conda/lib/orca_app/orca "$@"' > /opt/conda/bin/orca; \
    rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*

RUN jupyter serverextension enable --py jupyterlab \
    && jupyter nbextension enable --py widgetsnbextension \
    && jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        jupyter-matplotlib \
        jupyterlab_bokeh \
        @pyviz/jupyterlab_pyviz \
        @jupyterlab/plotly-extension \
        @mflevine/jupyterlab_html

#
# Configure environment
#
# Use 1000 for uid and gid. It's common in the Resero environments for a host directory to be mounted
# into the container, when this is done, it's also common for the uid/gid of the user doing so to be
# 1000. This allows for "correct" file priveledges when doing so
ENV NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=1000

# assumes that the project has been mounted into /home/jovyan/project
# to ensure this derived projects should add the following to their dockerutils.cfg file
# [notebook]
# volumes=--mount type=bind,source={project_root},target=/home/jovyan/project

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER; \
    usermod -aG sudo $NB_USER

# if you want to allow jovyan to sudo, for instance to be able to conda install, then RUN the following:
# RUN echo "jovyan ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/jovyan

COPY root/ /

# need to do this so that conda environment carries over to su'd user and so that we can
# run orca as any user (jovyan in this case)
RUN chmod a+rwx /root; \
    chmod a+rwx /tmp

RUN source conda base; \
    pip install --no-cache-dir \
        credstash \
        networkx \
    ; \
    rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*

CMD ["/usr/local/bin/start-notebook.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

