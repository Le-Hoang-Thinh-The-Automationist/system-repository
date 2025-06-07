# Use the official Nginx image
FROM nginx:latest

# Copy custom Nginx configuration file to the container
COPY nginx.conf /etc/nginx/nginx.conf

# Copy website files (optional)
COPY html/ /usr/share/nginx/html/

# Expose default HTTP and HTTPS ports
EXPOSE 80 443

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
