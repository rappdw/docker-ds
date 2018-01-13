FROM rappdw/nvidia-python:p3.6.3-u16.04-c8.0-n6.0

RUN apt-get update && apt-get install --no-install-recommends --allow-unauthenticated -y \
    build-essential \
    bzip2 \
    ca-certificates \
    curl \
    git \
    gfortran \
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

ADD requirements.txt /tmp/
RUN pip install -r /tmp/requirements.txt

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
COPY docker/notebook/start-singleuser.sh /usr/local/bin/
COPY docker/notebook/jupyter_notebook_config.py /etc/jupyter/
RUN fix-permissions /etc/jupyter/
USER $NB_USER