# Use the official Ubuntu image
FROM ubuntu:latest

# Update package list and install Bind9
RUN apt-get update && \
    apt-get install -y bind9 bind9utils bind9-doc && \
    rm -rf /var/lib/apt/lists/*

# Copy custom Bind9 configuration files
COPY named.conf.options     /etc/bind/named.conf.options
COPY named.conf.local       /etc/bind/named.conf.local
COPY db.backend.com         /etc/bind/db.backend.com
COPY db.internal-infra.com  /etc/bind/db.internal-infra.com

# Expose DNS ports
EXPOSE 53/udp
EXPOSE 53/tcp

# Start Bind9 service
CMD ["named", "-g", "-c", "/etc/bind/named.conf"]
