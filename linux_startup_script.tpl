#! /bin/bash
cd /tmp
mkdir elasticagent1
cd elasticagent1
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.8.1-linux-x86_64.tar.gz
tar xzvf elastic-agent-8.8.1-linux-x86_64.tar.gz
cd elastic-agent-8.8.1-linux-x86_64
sudo ./elastic-agent install --url=https://6d7f607d7dde4bebb494f4442612e81c.fleet.asia-south1.gcp.elastic-cloud.com:443 --enrollment-token=eGZmWEI0Y0JKa2lQcllRd2NNWFg6T1Z6SmRlX1VST0N0c1RNNEFEVWVXUQ== --force --tag gcp,linux
rm -rf elasticagent1
EOF