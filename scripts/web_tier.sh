#!/bin/bash

# Update the package list
apt-get update

# Install Nginx
apt-get install -y nginx

# Configure Nginx to serve the health check endpoint and a simple root response
cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;

    # Serve health check endpoint
    location /health {
        default_type text/plain;
        return 200 'OK';
    }

    # Serve "Hello World! This is the web tier!" at the root
    location / {
        default_type text/plain;
        return 200 'Hello World\n';
    }
}
EOF

# Restart Nginx to apply changes
systemctl restart nginx

# Ensure Nginx is enabled to start on boot
systemctl enable nginx
