FROM rappdw/nvidia-python:tf-1.4.0

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

COPY usr_local_bin/* /usr/local/bin/
COPY etc_jupyter/* /etc/jupyter/
COPY requirements.txt /tmp/

# Create jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    fix-permissions $HOME

EXPOSE 8888
WORKDIR $HOME

RUN fix-permissions /etc/jupyter/ \
    && wget -q https://nodejs.org/dist/v8.9.4/node-v8.9.4-linux-x64.tar.xz && \
    tar -xf node-v8.9.4-linux-x64.tar.xz && \
    cp -r node-v8.9.4-linux-x64/bin/* /usr/local/bin && \
    cp -r node-v8.9.4-linux-x64/include/* /usr/local/include && \
    cp -r node-v8.9.4-linux-x64/lib/* /usr/local/lib && \
    cp -r node-v8.9.4-linux-x64/share/* /usr/local/share && \
    rm -rf node-v8.9.4-linux-x64 node-v8.9.4-linux-x64.tar.xz \
    && pip install -r /tmp/requirements.txt \
    && setup-labs.sh \
    && fix-permissions /home/$NB_USER/.jupyter \
    && fix-permissions /home/$NB_USER/.config \
    && fix-permissions /home/$NB_USER/.npm \
    && fix-permissions /usr/local/share/jupyter/kernels \
    && fix-permissions /.cpu-env \
    && fix-permissions /.gpu-env \
    && fix-permissions /usr/local/bin \
    && cp /root/.bashrc /home/$NB_USER/ \
    && cp /root/.bash_profile /home/$NB_USER/


RUN mkdir /.cpu-env/share \
    && cp -r /usr/local/share/jupyter /.cpu-env/share \
    && cp /usr/local/bin/jupyter* /.cpu-env/bin \
    && mkdir /.gpu-env/share \
    && cp -r /usr/local/share/jupyter /.gpu-env/share \
    && cp /usr/local/bin/jupyter* /.gpu-env/bin

USER $NB_USER
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["start-project-notebook.sh"]

