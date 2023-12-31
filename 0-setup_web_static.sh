#!/usr/bin/env bash
# install Nginx if not already installed
if ! command -v nginx &> /dev/null; then
    sudo apt-get update
    sudo apt-get -y install nginx
fi

# Create necessary folders if they don't exist
folders=("/data/" "/data/web_static/" "/data/web_static/releases/" "/data/web_static/shared/" "/data/web_static/releases/test/")
for folder in "${folders[@]}"; do
    if [ ! -d "$folder" ]; then
        sudo mkdir -p "$folder"
    fi
done

# Create a fake HTML file for testing
echo "<html><head></head><body>Holberton School</body></html>" | sudo tee /data/web_static/releases/test/index.html

# Create symbolic link, delete and recreate if it already exists
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership to the ubuntu user and group
sudo chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
if [ -f "$config_file" ]; then
    # Add alias to serve content from /data/web_static/current/
    sudo sed -i '/server_name _;/a\\n\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' "$config_file"
    # Restart Nginx
    sudo service nginx restart
fi

# Exit successfully
exit 0
