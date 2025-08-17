# Use a specific version of the Prometheus image
FROM prom/prometheus:v2.45.0

# Set the working directory
WORKDIR /etc/prometheus

# Copy the Prometheus configuration file into the container
COPY prometheus.yml .

# Expose Prometheus port
EXPOSE 9090

# Run Prometheus
CMD ["--config.file=/etc/prometheus/prometheus.yml"]
