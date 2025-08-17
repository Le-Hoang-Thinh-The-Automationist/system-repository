
$wsl_ip="172.17.240.68" 
$port="46305"

# Remove existing port forwarding rule (if any)
netsh interface portproxy delete v4tov4 listenport=$port

# Add new port forwarding rule
netsh interface portproxy add v4tov4 listenport=$port connectport=$port connectaddress=$wsl_ip

# Allow traffic through Windows Firewall
netsh advfirewall firewall add rule name='WSL Port Forwarding' dir=in action=allow protocol=TCP localport=$port

netsh interface portproxy show v4tov4
