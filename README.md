# Docker Container for Data Science Notebooks

A mashup of the jupyterlab and the NVidia CUDA container
with Python 3 hand installed and using credstash to manage any secrets (notebook password,
github plugin oauth, etc.)

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

#### Google Drive
[Realtime Collaboration via Google Drive](https://github.com/jupyterlab/jupyterlab-google-drive/blob/master/docs/advanced.md#Realtime-API)

Requires credstash credential named: google.drive.client_id

## Versions

* 1.0.16 - Generialization of base image
* 1.0.15 - start-project-notebook.sh more robust
* 1.0.14 - Add labmanager and matplotlib jupyterlab extensions
* 1.0.13 - Include GraphViz in the image
* 1.0.12 - Update to latest CUDA cdNN Tensorflow
* 1.0.11 - Include Tensorflow (both CPU and GPU, using dockerutils handling of GPU)
        - add start-project-notebook.sh (derived project simplification)
* 1.0.10 - No changes to Dockerfile source, rebuild to pick up latest jupyterlab beta (v0.31.10)