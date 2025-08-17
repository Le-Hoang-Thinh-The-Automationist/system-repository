{{ with secret "minikube-kv/application-ns/database" }}
DB_USER ="{{ .Data.data.username }}"
DB_PASS ="{{ .Data.data.password }}"
DB_URL  ="{{ .Data.data.db_url }}"
DB_PORT ="{{ .Data.data.db_port }}"
DB_NAME ="{{ .Data.data.db_name }}"
{{ end }}
