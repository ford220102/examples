# Start with the official Python image
FROM python:3.8-slim

# Switch to root user to install packages and perform necessary setup
USER root

# Update and install necessary system packages
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
  graphviz

# Switch to the user (usually non-root) for running Jupyter
USER $NB_UID

# Install JupyterLab and necessary extensions
RUN pip install jupyterlab

# Install the Plotly extension for JupyterLab
RUN jupyter labextension install @jupyterlab/plotly-extension

# Install the Almond Scala kernel (adjust the version as needed)
RUN curl -Lo almond.zip https://github.com/almond-sh/almond/archive/refs/tags/v0.14.0.zip && \
    unzip almond.zip && \
    cd almond-0.14.0 && \
    ./cs launch "almond:0.14.0" --scala 2.12.12 -- \
    --install \
    --id scala212 \
    --display-name "Scala (2.12)" \
    --env "JAVA_OPTS=-XX:MaxRAMPercentage=80.0" \
    --variable-inspector && \
    rm almond.zip && \
    rm -rf almond-0.14.0

# Copy notebooks or files into the container and set appropriate permissions
COPY --chown=1000:100 notebooks/ $HOME

# Expose the necessary port for JupyterLab
EXPOSE 8888

# Set the default command to start JupyterLab
CMD ["jupyter", "lab", "--ip='0.0.0.0'", "--port=8888", "--allow-root"]
