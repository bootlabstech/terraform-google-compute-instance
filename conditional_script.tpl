# conditional_script.tpl

# This is a conditional script
<% if condition %>
# Large string for condition being true
cd /tmp
mkdir elasticagent1
cd /elasticagent1
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.6.2-linux-x86_64.tar.gz
tar xzvf elastic-agent-8.6.2-linux-x86_64.tar.gz
cd elastic-agent-8.6.2-linux-x86_64
sudo ./elastic-agent install --url=https://6d7f607d7dde4bebb494f4442612e81c.fleet.asia-south1.gcp.elastic-cloud.com:443 --enrollment-token=S21XcTJZWUIzVFM3bm9iQVY2c246VTNVRlE1WFVROWlMSXUwWldjM2RhZw== --force --tag azure,linux
rm -rf elasticagent1

<% else %>
# Large string for condition being false
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
cd\
md temp
cd temp
Invoke-WebRequest -Uri https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.6.2-windows-x86_64.zip -OutFile elastic-agent-8.6.2-windows-x86_64.zip
Expand-Archive .\elastic-agent-8.6.2-windows-x86_64.zip -DestinationPath .
cd elastic-agent-8.6.2-windows-x86_64
.\elastic-agent.exe install --url=https://6d7f607d7dde4bebb494f4442612e81c.fleet.asia-south1.gcp.elastic-cloud.com:443 --enrollment-token=S21XcTJZWUIzVFM3bm9iQVY2c246VTNVRlE1WFVROWlMSXUwWldjM2RhZw== --force --tag azure,windows
<% endif %>