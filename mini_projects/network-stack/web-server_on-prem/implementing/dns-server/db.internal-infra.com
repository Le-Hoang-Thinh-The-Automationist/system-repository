$TTL 86400
@   IN  SOA  ns1.internal-infra.com. admin.internal-infra.com. (
        2025060701  ; Serial
        3600        ; Refresh
        1800        ; Retry
        604800      ; Expire
        86400      ) ; Minimum TTL

    IN  NS  ns1.internal-infra.com.
    
ns1 IN  A   192.168.3.10
prometheus IN  A   192.168.3.10
grafana IN  A   192.168.3.10
