FROM rappdw/nvidia-python-node

RUN chmod 1777 /tmp \
    && apt-get update && apt-get install --no-install-recommends --allow-unauthenticated -y \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    git \
    gfortran \
    graphviz \
    libatlas-base-dev \
    libblas-common \
    libblas3 \
    libblas-dev \
    libffi-dev \
    libfreetype6 \
    libfreetype6-dev \
    libjpeg8 \
    libjpeg8-dev \
    liblapack-dev \
    libreadline6 \
    libreadline6-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    locales \
    openssl \
    pkg-config \
    sudo \
    vim \
    wget \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# assumes that the project has been mounted into /home/jovyan/project
# to ensure this derived projects should add the following to their dockerutils.cfg file
# [notebook]
# volumes=--mount type=bind,source={project_root},target=/home/jovyan/project
ENV HOME=/home/$NB_USER

COPY root/ /

# Bokeh and Holoviews extensions don't work with latest jupyerlab just yet...
#    jupyter labextension install \
#        @jupyter-widgets/jupyterlab-manager \
#        jupyter-matplotlib \
#        jupyterlab_bokeh \
#        @pyviz/jupyterlab_holoviews \
#        @jupyterlab/plotly-extension \
#        qgrid \
#        @jpmorganchase/perspective-jupyterlab \
#        pylantern \

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER \
    && sudo -H pip install -r /tmp/requirements.txt \
    && jupyter serverextension enable --py jupyterlab \
    && jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        @pyviz/jupyterlab_holoviews \
        @jupyterlab/plotly-extension \
        jupyter-matplotlib \
    && fix-permissions $HOME \
    && fix-permissions /etc/jupyter/ \
    && fix-permissions /home/$NB_USER/.jupyter \
    && fix-permissions /home/$NB_USER/.config \
    && fix-permissions /home/$NB_USER/.npm \
    && fix-permissions /usr/local/share/jupyter/kernels \
    && fix-permissions /.cpu-env \
    && fix-permissions /.gpu-env \
    && fix-permissions /usr/local/bin \
    && mkdir /.cpu-env/share \
    && cp -r /usr/local/share/jupyter /.cpu-env/share \
    && cp /usr/local/bin/jupyter* /.cpu-env/bin \
    && mkdir /.gpu-env/share \
    && cp -r /usr/local/share/jupyter /.gpu-env/share \
    && cp /usr/local/bin/jupyter* /.gpu-env/bin \
    && fix-permissions /usr/local

EXPOSE 8888
WORKDIR $HOME
ENV WORKDIR=$HOME/project
USER $NB_USER
CMD ["start-notebook.sh"]

