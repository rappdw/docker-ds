FROM continuumio/miniconda3

# 1) apt-install lilbraries we'll need for running without an xwindow and requisite libraries for
# plotly-orca
# 2) update conda
# 3) install what we'll need for the base env to support jupyter we'll diverge a bit from the AWS Deep Learning AMI
# as this is a miniconda environment, but we'll try to keep it close (pull most of the info from the
# conda-meta/history file for the base image in AWS Deep Learning AMI
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
    conda update --yes --quiet -n base conda; \
    conda install --yes --quiet \
        python=3.6 \
        pykerberos=1.2.1 \
    ; \
    conda install --yes --quiet -c conda-forge \
        nb_conda=2.2.1 \
        protobuf=3.6.0 \
        openmpi=3.1.0 \
    ; \
    conda install --yes --quiet \
        bokeh=0.12.13 \
        openjdk=8.0.121 \
        s3fs=0.1.5 \
        graphviz=2.40.1 \
        h5py=2.8.0 \
    ; \
    conda install --yes --quiet -c plotly plotly-orca; \
    conda install --yes --quiet \
        autovizwidget \
        bkcharts \
        cython \
        holoviews \
        jupyter \
        jupyterlab \
        jupyterlab_launcher \
        networkx \
        nodejs \
        pandas \
        plotly \
        psutil \
        psycopg2 \
        python=3.6 \
        pyviz_comms \
        scikit-image \
        scikit-learn \
        scipy \
        seaborn \
        sympy \
    ; \
    printf '#!/bin/bash \nxvfb-run -a /opt/conda/lib/orca_app/orca "$@"' > /opt/conda/bin/orca; \
    pip install --no-cache-dir environment_kernels; \
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
    ; \
    rm -rf /var/tmp/* /tmp/* /var/lib/apt/lists/*

USER $NB_USER
RUN set -ex; \
    mkdir -p ~/.jupyter; \
    echo "c = get_config() \n\
c.NotebookApp.kernel_spec_manager_class = 'environment_kernels.EnvironmentKernelSpecManager' \n\
c.EnvironmentKernelSpecManager.display_name_template=\"{}\" \n\
c.EnvironmentKernelSpecManager.conda_prefix_template=\"{}\" \n\
c.NotebookApp.iopub_data_rate_limit = 10000000000" >> ~/.jupyter/jupyter_notebook_config.py
RUN conda init
USER root

CMD ["/usr/local/bin/start-notebook.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

