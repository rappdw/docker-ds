#####
#
# Use Tensorflow wheel built for alpine (see: https://github.com/better/alpine-tensorflow)
#
####
FROM python:3.6.5-slim-stretch

COPY root/ /
RUN cd /tmp; \
    pip install --no-cache-dir pipenv; \
    pipenv install --system
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
    && cd / \
	&& apt-get clean \
    && rm -rf /var/tmp /tmp /var/lib/apt/lists/* \
    && mkdir -p /var/tmp /tmp

RUN jupyter serverextension enable --py jupyterlab \
    && jupyter nbextension enable --py widgetsnbextension \
    && jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager \
        jupyter-matplotlib \
        jupyterlab_bokeh \
        @pyviz/jupyterlab_pyviz \
        @jupyterlab/plotly-extension

#
# Configure environment
ENV NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=1000

# assumes that the project has been mounted into /home/jovyan/project
# to ensure this derived projects should add the following to their dockerutils.cfg file
# [notebook]
# volumes=--mount type=bind,source={project_root},target=/home/jovyan/project

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

CMD ["/usr/local/bin/start-notebook.sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

