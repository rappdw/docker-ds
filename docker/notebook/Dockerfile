FROM resero/nvidia-python:u16.04-p3.6.3-cuda8.0-cudnn6.0

RUN apt-get update && apt-get install --no-install-recommends --allow-unauthenticated -y \
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
&& rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV HOME=/home/$NB_USER

ADD docker/notebook/fix-permissions /usr/local/bin/fix-permissions

# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    fix-permissions $HOME

EXPOSE 8888
WORKDIR $HOME

# Add local files as late as possible to avoid cache busting
COPY docker/notebook/start.sh /usr/local/bin/
COPY docker/notebook/start-notebook.sh /usr/local/bin/
COPY docker/notebook/start-project-notebook.sh /usr/local/bin/
COPY docker/notebook/start-singleuser.sh /usr/local/bin/
COPY docker/notebook/setup-labs.sh /usr/local/bin/
COPY docker/notebook/setup-venv.py /usr/local/bin/
COPY docker/notebook/jupyter_notebook_config.py /etc/jupyter/
COPY docker/notebook/fix-shebang /usr/local/bin/fix-shebang

RUN fix-permissions /etc/jupyter/

RUN wget -q https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz && \
    tar -xf node-v8.9.4-linux-x64.tar.xz && \
    cp -r node-v8.9.4-linux-x64/bin/* /usr/local/bin && \
    cp -r node-v8.9.4-linux-x64/include/* /usr/local/include && \
    cp -r node-v8.9.4-linux-x64/lib/* /usr/local/lib && \
    cp -r node-v8.9.4-linux-x64/share/* /usr/local/share && \
    rm -rf node-v8.9.4-linux-x64 node-v8.9.4-linux-x64.tar.xz


COPY requirements*.txt /tmp/

# Setup Tensorflow (both CPU and GPU variants)
RUN setup-venv.py
RUN fix-permissions /.cpu-env
RUN fix-permissions /.gpu-env

RUN pip install -r /tmp/requirements.txt
RUN . /cpu-env \
    && pip install -r /tmp/requirements-cpu.txt
RUN . /gpu-env \
    && pip install -r /tmp/requirements-gpu.txt

# setup the default jupyter lab extensions
RUN setup-labs.sh

RUN fix-permissions /home/$NB_USER/.jupyter
RUN fix-permissions /home/$NB_USER/.config
RUN fix-permissions /home/$NB_USER/.npm
RUN fix-permissions /usr/local/share/jupyter/kernels

# A bit of a hack to allow jupyter to be installed in  system site-packages,
# but started from a virtual environment, picking up any modules in that virtual environment
RUN fix-shebang /usr/local/bin/jupyter*
RUN mkdir /.cpu-env/share \
    && cp -r /usr/local/share/jupyter /.cpu-env/share \
    && cp /usr/local/bin/jupyter* /.cpu-env/bin \
    && mkdir /.gpu-env/share \
    && cp -r /usr/local/share/jupyter /.gpu-env/share \
    && cp /usr/local/bin/jupyter* /.gpu-env/bin

USER $NB_USER
CMD start-notebook.sh

