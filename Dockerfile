#####
#
# Use Tensorflow wheel built for alpine (see: https://github.com/better/alpine-tensorflow)
#
####
FROM alpine:3.7 as builder

RUN apk add --no-cache python3 python3-tkinter freetype libpng libjpeg-turbo imagemagick graphviz git
RUN apk add --no-cache --virtual=.build-deps \
        bash \
        cmake \
        curl \
        freetype-dev \
        g++ \
        grep \
        libjpeg-turbo-dev \
        libpng-dev \
        linux-headers \
        make \
        musl-dev \
        openblas-dev \
        openjdk8 \
        patch \
        perl \
        python3-dev \
        rsync \
        sed \
        swig \
        zip \
    && cd /tmp \
    && $(cd /usr/bin && ln -s pip3 pip) \
    && pip install -U pip \
    && pip install --no-cache-dir wheel \
    && $(cd /usr/bin && ln -s python3 python)

RUN pip install https://github.com/better/alpine-tensorflow/releases/download/alpine3.7-tensorflow1.7.0/tensorflow-1.7.0-cp36-cp36m-linux_x86_64.whl

COPY root/tmp/requirements.txt /tmp/requirements.txt

RUN apk add --no-cache \
        gfortran \
        postgresql-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev

RUN pip install -r /tmp/requirements.txt

RUN pip freeze | grep -v tensorflow > /tmp/requirements.txt \
    && cd /root \
    && pip wheel -r /tmp/requirements.txt


FROM python:3.6.5-alpine3.7

COPY --from=builder /root/*.whl /root/
RUN pip3 install --no-cache-dir /root/*.whl \
    && pip3 install --no-cache-dir https://github.com/better/alpine-tensorflow/releases/download/alpine3.7-tensorflow1.7.0/tensorflow-1.7.0-cp36-cp36m-linux_x86_64.whl

RUN apk add --no-cache \
        nodejs \
        ca-certificates \
        libstdc++ \
        openblas \
        shadow

RUN jupyter serverextension enable --py jupyterlab \
    && jupyter nbextension enable --py widgetsnbextension \
    && jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        jupyter-matplotlib \
        jupyterlab_bokeh \
        @pyviz/jupyterlab_pyviz \
        @jupyterlab/plotly-extension

COPY root/ /

# Configure environment
ENV NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=1000

# assumes that the project has been mounted into /home/jovyan/project
# to ensure this derived projects should add the following to their dockerutils.cfg file
# [notebook]
# volumes=--mount type=bind,source={project_root},target=/home/jovyan/project

RUN addgroup -g $NB_GID -S $NB_USER \
    && adduser -u $NB_UID -S $NB_USER -G $NB_USER -s /bin/ash

CMD ["/usr/local/bin/start-notebook.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

