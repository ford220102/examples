FROM ubuntu:20.04

# Ensure we are root
USER root

# Update system and install dependencies
RUN apt-get update -y && apt-get install -y \
  sudo \
  git \
  curl \
  build-essential

# Clone the repository
RUN git clone https://github.com/foxytouxxx/freeroot.git /freeroot

# Run the root.sh script
WORKDIR /freeroot
RUN bash root.sh

# Set up environment (if needed)
CMD ["bash"]
