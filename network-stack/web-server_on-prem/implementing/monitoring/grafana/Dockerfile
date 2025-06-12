# Use a specific version of the Grafana image
FROM grafana/grafana:10.0.0

# Set the working directory
WORKDIR /var/lib/grafana

# Expose Grafana port
EXPOSE 3000

# Copy configuration files if needed
COPY grafana.ini        /etc/grafana/grafana.ini
COPY datasources.yml    /etc/grafana/provisioning/datasources/datasources.yml
COPY dashboards.yml    /etc/grafana/provisioning/dashboards/dashboards.yml

COPY dashboards/        /etc/dashboards/

# Run Grafana
CMD ["/run.sh"]