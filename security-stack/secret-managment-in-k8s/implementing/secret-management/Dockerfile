# Use stable HashiCorp Vault image
FROM hashicorp/vault:1.13.3

# Set Vault environment variables
ENV VAULT_ADDR=http://127.0.0.1:8200
ENV VAULT_API_ADDR=http://127.0.0.1:8200

# Create Vault configuration directory
RUN mkdir -p /vault/config

# Copy Vault configuration files (ensure config files exist in the same directory as Dockerfile)
COPY ./config/vault.hcl /vault/config/vault.hcl

# Set Vault storage backend directory (if using file storage)
RUN mkdir -p /vault/data && chown vault -R /vault

VOLUME /vault/data


# Expose Vault API port
EXPOSE 8200

# Set Vault entrypoint
CMD ["vault", "server", "-config=/vault/config/vault.hcl"]
