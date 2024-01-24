# Create Prometheus user
echo "Creation Prometheus user..."
sudo useradd \
 - system \
 - no-create-home \
 - shell /bin/false prometheus
echo "Done"
echo "----------------------------------------"


# Download the Prometheus file on the Monitoring Server
echo "Downloading the Prometheus file..."
wget https://github.com/prometheus/prometheus/releases/download/v2.49.0-rc.1/prometheus-2.49.0-rc.1.linux-amd64.tar.gz
echo "Done"
echo "----------------------------------------"


# Untar the Prometheus downloaded package
echo "Untar the Prometheus downloaded package..."
tar -xvf prometheus-2.49.0-rc.1.linux-amd64.tar.gz
echo "Done"
echo "----------------------------------------"


# Create two directories /data and /etc/prometheus to configure the Prometheus
echo "Creation two directories /data and /etc/prometheus..."
sudo mkdir -p /data /etc/prometheus
Now, enter into the prometheus package file that you have untar in the earlier step.
cd prometheus-2.49.0-rc.1.linux-amd64/
echo "Done"
echo "----------------------------------------"


# Move the prometheus and promtool files package in /usr/local/bin
sudo mv prometheus promtool /usr/local/bin/
echo "Done"
echo "----------------------------------------"


Move the console and console_libraries and prometheus.yml in the /etc/prometheus
echo "Moving the console and console_libraries and prometheus.yml in the /etc/prometheus..."
sudo mv consoles console_libraries/ prometheus.yml /etc/prometheus/
echo "Done"
echo "----------------------------------------"


Provide the permissions to prometheus user
echo "Providing the permissions to prometheus user..."
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
echo "Done"
echo "----------------------------------------"


Check and validate the Prometheus
echo "Checking and validating the Prometheus..."
prometheus --version
echo "Done"
echo "----------------------------------------"


# Specify the path to the systemd configuration file
echo "Editing the file /etc/systemd/system/prometheus.service..."

systemd_config_file="/etc/systemd/system/prometheus.service"

# Prometheus configuration
prometheus_config="[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5
[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \
 -config.file=/etc/prometheus/prometheus.yml \
 -storage.tsdb.path=/data \
 -web.console.templates=/etc/prometheus/consoles \
 -web.console.libraries=/etc/prometheus/console_libraries \
 -web.listen-address=0.0.0.0:9090 \
 -web.enable-lifecycle
[Install]
WantedBy=multi-user.target"

# Edit the systemd configuration file
echo "Editing the file $systemd_config_file..."
sudo bash -c "echo '$prometheus_config' > $systemd_config_file"
echo "Done"
echo "----------------------------------------"


# Once you write the systemd configuration file for Prometheus, then enable it and start the Prometheus service.
echo "Starting the Prometheus service..."
sudo systemctl enable prometheus.service
sudo systemctl start prometheus.service
systemctl status prometheus.service
echo "Done"
echo "----------------------------------------"


# Now, we have to install a node exporter to visualize the machine or hardware level data such as CPU, RAM, etc on our Grafana dashboard.
# To do that, we have to create a user for it.
echo "Creating node exporter user..."
sudo useradd \
 - system \
 - no-create-home \
 - shell /bin/false node_exporter
echo "Done"
echo "----------------------------------------"


# Download the node exporter package
echo "Downloading the node exporter package..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
echo "Done"
echo "----------------------------------------"

# Untar the node exporter package file and move the node_exporter directory to the /usr/local/bin directory
echo "..."
tar -xvf node_exporter-1.7.0.linux-amd64.tar.gz
sudo mv node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin/
echo "Done"
echo "----------------------------------------"

Validate the version of the node exporter
echo "..."
node_exporter --version
echo "Done"
echo "----------------------------------------"

Create the systemd configuration file for node exporter.
echo "..."
sudo vim /etc/systemd/system/node_exporter.service
echo "Done"
echo "----------------------------------------"

Copy the below configurations and paste them into the /etc/systemd/system/node_exporter.service file.

[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=500
StartLimitBurst=5
[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/node_exporter \
 - collector.logind
[Install]
WantedBy=multi-user.target
echo "Done"
echo "----------------------------------------"

Enable the node exporter systemd configuration file and start it.
echo "..."
sudo systemctl enable node_exporter
sudo systemctl enable node_exporter
systemctl status node_exporter.service
echo "Done"
echo "----------------------------------------"

# Now, we have to add a node exporter to our Prometheus target section. So, we will be able to monitor our server.
echo 'Appending to /etc/prometheus/prometheus.yml...'
echo '  - job_name: "node_exporter"' | sudo tee -a /etc/prometheus/prometheus.yml
echo '    static_configs:' | sudo tee -a /etc/prometheus/prometheus.yml
echo '      - targets: ["localhost:9100"]' | sudo tee -a /etc/prometheus/prometheus.yml
echo "Done"
echo "----------------------------------------"

# After saving the file, validate the changes that you have made using promtool.
echo "validating the changes..."
promtool check config /etc/prometheus/prometheus.yml
echo "Done"
echo "----------------------------------------"

# If your changes have been validated then, push the changes to the Prometheus server.
echo "Pushing the changes to the Prometheus server..."
curl -X POST http://localhost:9090/-/reload
echo "Done"
echo "----------------------------------------"

# Now, install the Grafana tool to visualize all the data that is coming with the help of Prometheus.
echo "Installing the Grafana tool to visualize the data..."
sudo apt-get install -y apt-transport-https software-properties-common wget
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg - dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com beta main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
echo "Done"
echo "----------------------------------------"

# Install the Grafana
echo "Installing the Grafana..."
sudo apt-get install grafana
echo "Done"
echo "----------------------------------------"

# Enable and start the Grafana Service
echo "Starting the Grafana Service..."
sudo systemctl enable grafana-server.service
sudo systemctl start grafana-server.service
sudo systemctl status grafana-server.service
echo "Done"
echo "----------------------------------------"
