# Use an ARM64-compatible base image
FROM arm64v8/debian:latest

# Set the maintainer label
LABEL maintainer="Schelte Bron <otgw@tclcode.com>"

# Set the working directory inside the container
WORKDIR /usr/src/app

# Install necessary dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxft2 \
    curl \
    ca-certificates \
    tzdata && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create necessary directories with proper permissions
RUN mkdir -p /usr/local/bin && mkdir -p -m a=rwx /data /log

# Download the latest ARM64 otmonitor binary with error handling
RUN curl -fsSL -o /usr/local/bin/otmonitor https://otgw.tclcode.com/download/otmonitor-aarch64 && \
    chmod +x /usr/local/bin/otmonitor || \
    { echo "Failed to download otmonitor binary"; exit 1; }

# Expose the port used by otmonitor
EXPOSE 8080

# Set otmonitor as the entrypoint with default arguments
ENTRYPOINT ["/usr/local/bin/otmonitor", "--daemon", "-f/data/otmonitor.conf"]
CMD ["-w8080"]

# Set the log directory as the working directory
WORKDIR /log
