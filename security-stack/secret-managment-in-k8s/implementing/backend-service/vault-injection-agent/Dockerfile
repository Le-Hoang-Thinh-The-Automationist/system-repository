# Use stable HashiCorp Vault image
FROM hashicorp/vault:1.13.3

COPY ./config/    /vault/config/
COPY ./secrets/   /vault/secrets/

RUN mkdir -p /vault/output && \
    chown vault -R  /vault/config/ && \
    chown vault -R  /vault/secrets/ && \
    chown vault -R  /vault/output/

CMD ["agent", "-config=/vault/config/vault-agent-config.hcl"]