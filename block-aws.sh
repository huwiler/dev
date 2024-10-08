#!/bin/bash

# Fetch the latest AWS IP ranges
wget -q https://ip-ranges.amazonaws.com/ip-ranges.json -O aws-ip-ranges.json

# Flush existing rules to avoid conflicts
iptables -F

# Parse the JSON and extract the IPv4 CIDR blocks
aws_ips=$(jq -r '.prefixes[].ip_prefix' aws-ip-ranges.json)

# Iterate over each AWS IP and block it with iptables
for ip in $aws_ips; do
  if ! iptables -C INPUT -s $ip -j DROP 2>/dev/null; then
     iptables -A INPUT -s $ip -j DROP
  fi
done

# Add essential ACCEPT rules afterward
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Drop all other incoming traffic
iptables -P INPUT DROP

iptables-save > /etc/iptables/rules.v4
netfilter-persistent save

echo "AWS traffic blocking rules applied and saved successfully."
