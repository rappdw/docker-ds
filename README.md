[![Build Status](https://img.shields.io/docker/automated/rappdw/docker-ds.svg)](https://hub.docker.com/r/rappdw/docker-ds/)

# Docker Container for Data Science Notebooks

This docker image provides an environment for using Jupyter for
data science. It includes a number of python libraries that are commonly 
used as well as several jupyter extensions that are useful, including:

* numpy
* scikit-learn
* pandas
* matplotlib
* bokeh
* seaborn
* holoviews

## VCS & Notebooks
While the `.ipynb` files are json, comparing the raw file formats aren't ideal for diffing changes, etc. In order to
better facilitate working with VCS, especially for human diff comprehension, this image support a jupyter save hook
that converts a notebook into `.py` and `.html` files in a `.diffs` sub-directory. To enable this, pass the envrionment
variable `DOCKER_DS_DIFFS=1` when starting the container. (See `run-notebook` command in 
[docker-utils](https://github.com/rappdw/docker-utils))

## Credentials
There are a number of credentials utlized by this container, including: notebook password, github plugin OAuth 
credentials, google drive OAuth credentials, etc.

The pattern for exposing these credentials to the docker container is to store the
credentials in credstash, and then bind mount the current user's .aws directory into
the container upon container start.

The code assumes an aws profile of 'ds-notebook'. If unable to access credstash, 
appropriate defaults will be used if available. In most cases extensions will not
function.

## Configuration
### dockerutils.cfg
If you use dockerutils, the following configuration will make a notebook available in your project. 
```ini
[notebook]
volumes=--mount type=bind,source={project_root},target=/home/jovyan/project -v /data:/data --mount type=bind,source=/Users/{user}/.aws,target=/home/jovyan/.aws
ports=-p 8888:8888
```

### AWS
In your ~/.aws directory create a credentials and config file simlar to the following:

**credentials**
```ini
[ds-notebook]
aws_secret_access_key = ...
aws_access_key_id = ....
```

**config**
```ini
[profile ds-notebook]
region = us-west-2
```

### Related Extensions
#### github
[Jupyterlab Github](https://github.com/jupyterlab/jupyterlab-github)

Requires credstash credentials named: github.client_id, github.client_secret
