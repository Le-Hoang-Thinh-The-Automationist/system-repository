#!/bin/bash

# Set certificate details
CA_KEY="ca.key"
CA_CERT="ca.crt"
CA_SUBJECT="/C=VN/ST=CA/L=/O=L.H.Thinh/CN=L.H.Thinh's CA Cert"

SERVER_KEY="backend-server.key"
SERVER_CSR="backend-server.csr"
SERVER_CERT="backend-server.crt"
SERVER_SUBJECT="/C=VN/ST=CA/L=/O=L.H.Thinh/CN=*.backend.com"


#  =========================    The CA cert is already generated, no need to generate it again   =========================

# Generate CA key
# openssl genpkey -algorithm RSA -out $CA_KEY -pkeyopt rsa_keygen_bits:4096

# Generate self-signed CA certificate
# openssl req -x509 -new -nodes -key $CA_KEY -sha256 -days 3650 -out $CA_CERT -subj "$CA_SUBJECT"

#  =======================================================================================================================

# Generate server private key
openssl genpkey -algorithm RSA -out $SERVER_KEY -pkeyopt rsa_keygen_bits:2048

# Generate certificate signing request (CSR)
openssl req -new -key $SERVER_KEY -out $SERVER_CSR -subj "$SERVER_SUBJECT"

# Sign the server certificate with the CA
openssl x509 -req -in $SERVER_CSR -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $SERVER_CERT -days 3650 -sha256

# Verify the certificate
openssl verify -CAfile $CA_CERT $SERVER_CERT

echo "SSL/TLS certificates generated successfully!"
echo "CA Certificate: $CA_CERT"
echo "Server Certificate: $SERVER_CERT"
echo "Server Private Key: $SERVER_KEY"
