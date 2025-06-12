#!/bin/bash

NGINX_HTTP_PORT="10080"
NGINX_HTTPS_PORT="10443"
fail_status=0


echo "Testing for Nginx is online"

# Step 1: Check if Nginx is responding on port 10080
if nc -zv localhost $NGINX_HTTP_PORT &> /dev/null
then
    echo "   ✔ Nginx is responding on port 80."
else
    echo "   ❌ Nginx is NOT reachable on port $NGINX_HTTP_PORT!"
    fail_status=1
fi

# Step 2: Test homepage response
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$NGINX_HTTP_PORT)
if [ "$RESPONSE" -eq 200 ]
then
    echo "   ✔ Homepage is loading successfully."
else
    echo "   ❌ Failed to load homepage! Received HTTP response: $RESPONSE"
    fail_status=1
fi


if [ "$fail_status" -eq 1 ]; then
    echo "❌ NGINX connection fails"
    echo ""
    exit 1
else
    echo "✅ NGINX connection is successful!"
    echo ""
fi