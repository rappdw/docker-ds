# Docker Container for Data Science Notebooks

A mashup of the jupyter data science notebook (sans Conda) and the NVidia CUDA container
with Python 3 hand installed

## Usage
It's easiest to use this container together with [dockerutils](https://pypi.python.org/pypi/dockerutils).

Create a docker directory in your repository and place the following dockerutils.cfg file in that directory:

```ini
[notebook]
volumes=-v {project_root}:/workdir
ports=-p 8888:8888
```
Create a notebook subdirectory and place the following Dockefile in that directory:

```dockerfile
FROM rappdw/docker-ds:latest

ADD requirements.txt /tmp/requirements.txt

RUN /bin/bash -c "source /home/jovyan/.venvs/notebook/bin/activate; pip install -r /tmp/requirements.txt" \
    && ln -s /workdir/notebooks notebooks

# install an editable version into the python module and then, start the jupyter server
CMD /bin/bash -c "source /home/jovyan/.venvs/notebook/bin/activate; pip install -e /workdir/; start-notebook.sh"

```
