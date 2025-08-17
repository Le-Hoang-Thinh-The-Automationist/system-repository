# Connect to Vault server
vault {
  address = "http://vault:8200"
}

# Local listener for Vault Agent
listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = true
}

# Auto-auth using AppRole
auto_auth {
  method "approle" {
    mount_path = "auth/minikube-roles"
    config = {
      role_id_file_path = "/vault/secrets/role-id"
      secret_id_file_path = "/vault/secrets/secret-id"
      remove_secret_id_file_after_reading = false
    }
  }

  sink "file"{
    config = {
      path = "/vault/secrets/vault-agent-token"
    }
  }
}

# Token caching for use with template
cache {
  use_auto_auth_token = true
}

# Template to render secret from Vault
template {
  source = "/vault/config/template.tpl"
  destination = "/vault/output/.env"
}
