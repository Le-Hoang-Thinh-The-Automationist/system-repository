# Use the official Nginx image
FROM nginx:1.27.5

# Copy custom Nginx configuration file to the container
COPY nginx.conf     /etc/nginx/nginx.conf
COPY nginx-conf/    /etc/nginx/nginx-conf/
COPY ssl-cert/           /etc/nginx/ssl/

# Copy website files (optional)
COPY html/ /usr/share/nginx/html/

# Expose default HTTP and HTTPS ports
EXPOSE 80 443

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
