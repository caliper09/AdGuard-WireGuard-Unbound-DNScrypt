FROM debian:bullseye-slim

# Install required packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gnupg \
    unbound \
    wireguard \
    iptables \
    dnscrypt-proxy \
    && rm -rf /var/lib/apt/lists/*

# Install AdGuard Home
RUN curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v

# Download root hints for Unbound
RUN wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.root

# Create necessary directories
RUN mkdir -p /etc/wireguard
RUN mkdir -p /etc/dnscrypt-proxy

# Copy configuration files
COPY config/unbound.conf /etc/unbound/unbound.conf
COPY config/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml
COPY config/AdGuardHome.yaml /opt/AdGuardHome/conf/AdGuardHome.yaml

# Expose required ports
EXPOSE 53/tcp 53/udp     # DNS
EXPOSE 3000/tcp          # AdGuard Home web interface
EXPOSE 51820/udp         # WireGuard

# Set environment variables
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Create startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
