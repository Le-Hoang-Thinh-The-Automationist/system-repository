#!/bin/bash

DNS_SERVER="192.168.3.11"
DOMAIN="service-1.backend.com"
EXPECTED_IP="192.168.3.10"
fail_status=0

echo "Checking if the DNS server is set to $DNS_SERVER..."

# Get the current system's configured DNS server
CURRENT_DNS=$(grep "nameserver" /etc/resolv.conf | awk '{print $2}' | head -n1)

if [[ "$CURRENT_DNS" != "$DNS_SERVER" ]]; then
    echo "   ❌ Error: Expected DNS server $DNS_SERVER, but found $CURRENT_DNS"
    fail_status=1
else
    echo "   ✔ DNS server is correctly set to $DNS_SERVER"
fi

# Perform lookup using nslookup
RESULT_IP=$(nslookup $DOMAIN $DNS_SERVER | awk '/Address: / {print $2}' | tail -n1)

if [[ "$RESULT_IP" == "$EXPECTED_IP" ]]; then
    echo "   ✔ Success! $DOMAIN resolves to $EXPECTED_IP"
else
    echo "   ❌ Error: Expected $EXPECTED_IP, but got $RESULT_IP"
    fail_status=1
fi

if [ "$fail_status" -eq 1 ]; then
    echo "❌ DNS server connection fails"
    echo ""
    exit 1
else
    echo "✅ DNS server connection is successful!"
    echo ""
fi