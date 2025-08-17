# Vault Default Configuration
ui = true


# Vault Configuration File
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1  
}

# Storage Backend Configuration
storage "file" {
  path = "/vault/data"
}

# Enable Telemetry Logging
telemetry {
  prometheus_retention_time = "24h"
}

