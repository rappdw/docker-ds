# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

from jupyter_core.paths import jupyter_data_dir
import subprocess
import os
import errno
import stat

c = get_config()
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False

try:
    from credstash import get_session_params, listSecrets, getSecret
    session_params = get_session_params('ds-notebook', None)
    items = [item['name'] for item in listSecrets(**session_params) if item['name'] in [
        'notebook.password', 'notebook.token', 'github.client_id', 'github.client_secret', 'google.drive.client_id'
    ]]
except Exception:
    items = []

if 'notebook.password' in items:
    c.NotebookApp.password = f"{getSecret('notebook.password', **session_params)}"
if 'notebook.token' in items:
    c.NotebookApp.token = f"{getSecret('notebook.token', **session_params)}"
if 'github.client_id' in items:
    c.GitHubConfig.client_id = f"{getSecret('github.client_id', **session_params)}"
if 'github.client_secret' in items:
    c.GitHubConfig.client_secret = f"{getSecret('github.client_secret', **session_params)}"
if 'google.drive.client_id' in items:
    google_drive_cfg_dir = '/home/jovyan/.jupyter/lab/user-settings/@jupyterlab/google-drive/'
    os.makedirs(google_drive_cfg_dir, exist_ok=True)
    with open(os.path.join(google_drive_cfg_dir, 'drive.jupyterlab-settings'), 'w') as f:
        f.write(
f'''{{
    "clientId": "{getSecret('google.drive.client_id', **session_params)}",
    "realtime": false
}}'''
        )

# Generate a self-signed certificate
if 'GEN_CERT' in os.environ:
    dir_name = jupyter_data_dir()
    pem_file = os.path.join(dir_name, 'notebook.pem')
    try:
        os.makedirs(dir_name)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(dir_name):
            pass
        else:
            raise
    # Generate a certificate if one doesn't exist on disk
    subprocess.check_call(['openssl', 'req', '-new',
                           '-newkey', 'rsa:2048',
                           '-days', '365',
                           '-nodes', '-x509',
                           '-subj', '/C=XX/ST=XX/L=XX/O=generated/CN=generated',
                           '-keyout', pem_file,
                           '-out', pem_file])
    # Restrict access to the file
    os.chmod(pem_file, stat.S_IRUSR | stat.S_IWUSR)
    c.NotebookApp.certfile = pem_file
