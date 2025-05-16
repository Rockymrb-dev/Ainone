FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV FILEBROWSER_PORT=13000
ENV TRANSMISSION_PORT=12000
ENV DOWNLOAD_DIR=/download

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl wget nano gnupg ca-certificates software-properties-common \
    transmission-daemon \
    openssh-client tmate \
    && rm -rf /var/lib/apt/lists/*

# Create download folder
RUN mkdir -p ${DOWNLOAD_DIR}

# Install FileBrowser
RUN curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
RUN mkdir -p /etc/filebrowser
RUN filebrowser config init \
    && filebrowser config set --port ${FILEBROWSER_PORT} --root ${DOWNLOAD_DIR}

# Configure Transmission
RUN mkdir -p /etc/transmission-daemon
COPY transmission-settings.json /etc/transmission-daemon/settings.json

# Expose ports
EXPOSE ${FILEBROWSER_PORT}
EXPOSE ${TRANSMISSION_PORT}

# Startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
