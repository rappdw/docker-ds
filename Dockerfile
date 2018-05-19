#####
#
# Use Tensorflow wheel built for alpine (see: https://github.com/better/alpine-tensorflow)
#
####
FROM python:3.6.5-slim-stretch

COPY root/ /
RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN chmod 1777 /tmp \
    && apt-get update \
    && apt-get install --no-install-recommends --allow-unauthenticated -y \
        curl \
        gnupg \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install --no-install-recommends --allow-unauthenticated -y \
        nodejs \
    && cd /tmp \
    && curl -o npm-5.7.1.tgz  https://registry.npmjs.org/npm/-/npm-5.7.1.tgz \
    && tar -xzf npm-5.7.1.tgz \
    && cd package \
    && ./scripts/install.sh \
	&& apt-get clean \
    && rm -rf /var/tmp /tmp /var/lib/apt/lists/* \
    && mkdir -p /var/tmp /tmp

#RUN apk add --no-cache \
#        nodejs \
#        ca-certificates \
#        libstdc++ \
#        openblas \
#        shadow
#
RUN jupyter serverextension enable --py jupyterlab \
    && jupyter nbextension enable --py widgetsnbextension \
    && jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        jupyter-matplotlib \
        jupyterlab_bokeh \
        @pyviz/jupyterlab_pyviz \
        @jupyterlab/plotly-extension

#COPY root/ /
#
## Configure environment
#ENV NB_USER=jovyan \
#    NB_UID=1000 \
#    NB_GID=1000
#
## assumes that the project has been mounted into /home/jovyan/project
## to ensure this derived projects should add the following to their dockerutils.cfg file
## [notebook]
## volumes=--mount type=bind,source={project_root},target=/home/jovyan/project
#
#RUN addgroup -g $NB_GID -S $NB_USER \
#    && adduser -u $NB_UID -S $NB_USER -G $NB_USER -s /bin/ash
#
#CMD ["/usr/local/bin/start-notebook.sh"]
#ENTRYPOINT ["/docker-entrypoint.sh"]
#
