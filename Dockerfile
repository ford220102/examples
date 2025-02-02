# Start with the base image
FROM python:3.8-slim

# Switch to root user to run system-level commands
USER root

# Update system and install necessary packages
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
  build-essential \
  python3-dev \
  python3-pip \
  python3-venv \
  nodejs \
  npm \
  curl \
  unzip \
  libssl-dev \
  libcurl4-openssl-dev \
  libjpeg-dev \
  liblcms2-dev \
  libblas-dev \
  liblapack-dev \
  gfortran \
  git \
  jq \
  sudo  # Ensure sudo is installed

# Install JupyterLab
RUN pip install jupyterlab

# Install JupyterLab extensions
RUN jupyter labextension install \
  jupyterlab-plotly \
  @almond-sh/scalafmt \
  @almond-sh/jupyterlab_variableinspector || echo "Failed to install JupyterLab extensions"

# Switch back to the user with the proper UID (if applicable)
USER $NB_UID

# Final setup: copy the notebooks directory and set permissions
COPY --chown=1000:100 notebooks/ $HOME

# Ensure the JupyterLab is built
RUN jupyter lab build --dev-build=False --minimize=False || echo "JupyterLab build failed"
