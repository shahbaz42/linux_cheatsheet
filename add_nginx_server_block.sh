#!/bin/bash

# Function to add server block to nginx config
add_server_block() {
    echo "server {
    listen 80;
    server_name $1;

    location / {
        proxy_pass http://localhost:$2;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}" | sudo tee /etc/nginx/sites-available/$1 > /dev/null
    sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/
    sudo systemctl reload nginx
}

# Function to install Certbot if not already installed
install_certbot() {
    if ! command -v certbot &> /dev/null; then
        echo "Certbot is not installed. Installing..."
        sudo snap install --classic certbot
    fi
}

# Input variables
read -p "Enter server name: " server_name
read -p "Enter port: " port

# Check if server block already exists
if [ -f "/etc/nginx/sites-available/$server_name" ]; then
    read -p "Server block for $server_name already exists. Do you want to delete it? (y/n): " delete_choice
    if [ "$delete_choice" == "y" ]; then
        sudo rm "/etc/nginx/sites-available/$server_name"
        sudo rm "/etc/nginx/sites-enabled/$server_name"
        sudo systemctl reload nginx
        echo "Existing server block deleted."
    else
        echo "No changes made."
        exit 0
    fi
fi

# Add server block
add_server_block $server_name $port

# Provide instructions for DNS setup
echo "New Server block added"
echo ">> Create an A record for $server_name with the value as the IP address of this server <<"
read -p "Press Enter when you have completed the above steps."

# Install Certbot if needed
install_certbot

# Run Certbot to configure SSL
sudo certbot --nginx -d $server_name

echo "SSL configuration for $server_name is now complete!"
