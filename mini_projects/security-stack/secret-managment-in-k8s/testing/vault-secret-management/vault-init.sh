#!/bin/bash

# Needed to run vault init 
export VAULT_ADDR=http://127.0.0.1:8200 


# Relative path of the Ansible playbook for initialization
script_folder="$(dirname "$(realpath "$0")")"
ansible_path="./../../implementing/configuration-management"

# For testing purpose, the init will be `local` 
host_group="minikube"
vault_server="vault.application.thinhlh9"

ansible-playbook -i "$ansible_path/inventory/$host_group-cluster.ini" "$ansible_path/playbook.yaml" \
                    -e "cluster=$host_group" \
                    -e "vault_server=$vault_server" \
                    # -vvvvv \
                    # --ask-become-pass
