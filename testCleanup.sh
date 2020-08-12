#!/bin/bash -e

echo "Test Cleanup Script"

# ask for user input
read -p 'DNSExit username: ' username
read -p 'DNSExit password: ' password
read -p 'DNSExit Domain:: ' domain

# export variables for authenticator
export DNSEXIT_USERNAME=${username}
export DNSEXIT_PASSWORD=${password}
export CERTBOT_DOMAIN=${domain}
export CERTBOT_VALIDATION=jfEVZCbJH_J96HjWXPNGoW0rpolrztrA-arVqPTre8c

# execute cleanup script
./cleanup.sh

# print success
echo "cleanup executed successfully"
