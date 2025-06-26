# Read access to KV-V2 secrets at minikube-kv/data/application-ns/database
  path "auth/minikube-roles/login" {
    capabilities = ["create", "read", "update"]
  }

path "minikube-kv/data/application-ns/database" {
  capabilities = ["read"]
}

# Required to read the metadata versioning
path "minikube-kv/metadata/application-ns/database" {
  capabilities = ["read"]
}

path "minikube-kv/application-ns/database" {
  capabilities = ["read"]
}