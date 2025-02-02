FROM python:3.8-slim

# Switch to root user
USER root

# Install necessary utilities
RUN apt-get update -y && apt-get install -y curl git jq sudo

# Copy the postBuild script into the container
COPY postBuild /usr/local/bin/postBuild

# Make the script executable
RUN chmod +x /usr/local/bin/postBuild

# Run the postBuild script
RUN /usr/local/bin/postBuild

# Expose port for JupyterLab
EXPOSE 8888

# Start JupyterLab (Optional)
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--allow-root"]
