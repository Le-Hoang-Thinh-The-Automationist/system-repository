# Run PowerShell as Administrator

# Delete existing rule (if any)
netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0
netsh interface portproxy delete v4tov4 listenport=443 listenaddress=0.0.0.0
netsh interface portproxy delete v4tov4 listenport=9090 listenaddress=0.0.0.0
netsh interface portproxy delete v4tov4 listenport=3000 listenaddress=0.0.0.0

# Create new forwarding rule
netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=10080 connectaddress=172.24.127.246
netsh interface portproxy add v4tov4 listenport=443 listenaddress=0.0.0.0 connectport=10443 connectaddress=172.24.127.246
netsh interface portproxy add v4tov4 listenport=9090 listenaddress=0.0.0.0 connectport=19090 connectaddress=172.24.127.246
netsh interface portproxy add v4tov4 listenport=3000 listenaddress=0.0.0.0 connectport=13000 connectaddress=172.24.127.246

# Verify the rule
netsh interface portproxy show all

# # Define existing IPv4 DNS servers
# $adapterName = (Get-NetAdapter | Where-Object {$_.Status -eq "Up"}).Name

# # Retrieve existing IPv4 DNS servers
# $existingDnsServers = (Get-DnsClientServerAddress -InterfaceAlias $adapterName).ServerAddresses

# #  Filter only IPv4 addresses (ignoring IPv6)
# $ipv4DnsServers = $existingDnsServers | Where-Object { $_ -match "^\d{1,3}(\.\d{1,3}){3}$" }

# # Add the new IPv4 DNS server
# $newDnsServers = @("172.24.127.246") + $ipv4DnsServers

# # Apply the updated list of IPv4 DNS servers
# Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses $newDnsServers

# # Verify the update
# Get-DnsClientServerAddress -InterfaceAlias $adapterName


