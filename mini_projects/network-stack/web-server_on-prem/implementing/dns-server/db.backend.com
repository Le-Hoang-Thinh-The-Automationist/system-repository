$TTL 86400
@   IN  SOA  ns1.backend.com. admin.backend.com. (
        2025060701  ; Serial
        3600        ; Refresh
        1800        ; Retry
        604800      ; Expire
        86400      ) ; Minimum TTL

    IN  NS  ns1.backend.com.
    IN  A   192.168.3.10

ns1 IN  A  192.168.3.10
service-1 IN  A   192.168.3.10
service-2 IN  A   192.168.3.10
