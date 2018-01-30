# Docker Container for Data Science Notebooks

A mashup of the jupyterlab and the NVidia CUDA container
with Python 3 hand installed and using credstash to manage any secrets (notebook password,
github plugin oauth, etc.)

## Usage
It's easiest to use this container together with [dockerutils](https://pypi.python.org/pypi/dockerutils).

Create a docker directory in your repository and place the following dockerutils.cfg file in that directory:

**NOTE**: The mount of .aws into the container is required in order to use credstash to set
notebook password and github plugin OAuth credentials.

Also, you must configure a 'ds-notebook' profile.

```ini
[notebook]
volumes=--mount type=bind,source={project_root},target=/home/jovyan/model-ner -v /data:/data --mount type=bind,source=/Users/{user}/.aws,target=/home/jovyan/.aws
ports=-p 8888:8888
```
Create a notebook subdirectory and place the following Dockefile in that directory:

```dockerfile
FROM rappdw/docker-ds

ADD pip.conf /home/jovyan/.pip/pip.conf
ADD requirements.txt /tmp/requirements.txt
ADD docker/notebook/start-repo-notebook.sh /usr/local/bin

RUN . /home/jovyan/.venvs/notebook/bin/activate \
    && pip install -r /tmp/requirements.txt

CMD start-repo-notebook.sh
```

```bash
#!/usr/bin/env bash

# get the password from credstash
. /home/jovyan/.venvs/notebook/bin/activate

# install an editable version of the ner module into site-packages
pip install -e /home/jovyan/repo/

# trust our notebooksc.NotebookApp.password
pushd /home/jovyan/repo/notebooks
for f in *.ipynb; do
    jupyter trust "$f"
done
popd

# start the notebook
start-notebook.sh
```
