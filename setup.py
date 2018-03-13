import versioneer
from setuptools import setup, find_packages

from codecs import open
from os import path

here = path.abspath(path.dirname(__file__))
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    long_description = f.read()


setup(
    name='docker_ds',
    version=versioneer.get_version(),
    cmdclass=versioneer.get_cmdclass(),
    description='Dockerized DataScience Notebook',
    long_description=long_description,
    url='https://github.com/rappdw/docker-ds.git',
    author='Daniel Rapp',
    author_email='rappdw@gmail.com',
    license='MIT',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: MIT',
        'Programming Language :: Python :: 3.6',
    ]
)
