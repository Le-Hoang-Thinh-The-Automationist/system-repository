# Networking for DevOps

This document outlines key networking concepts relevant to DevOps, categorized with one or two representative tools per concept. Each concept is critical for building, deploying, monitoring, and troubleshooting modern infrastructure.

---

## 1. **Networking Fundamentals**

### **1.1 IP Addressing & Subnetting**

* **Concept:** Understanding how IP addresses are structured and assigned, both in IPv4 and IPv6. This includes subnetting, which allows for efficient IP address management and traffic segmentation using CIDR (Classless Inter-Domain Routing) notation.
* **Tools:**

  * `ipcalc`: Useful for subnet calculations and validating IP ranges.

### **1.2 DNS (Domain Name System)**

* **Concept:** Resolves human-readable domain names into machine-readable IP addresses. Critical for service discovery and external communication.
* **Tools:**

  * `dig`: Query DNS servers and troubleshoot DNS-related issues.
  * `nslookup`: Resolve DNS names and query records (A, CNAME, MX, etc).

### **1.3 Routing & Switching**

* **Concept:** Involves directing network traffic between devices and networks. Routing determines the path packets take, while switching operates within the same network.
* **Tools:**

  * `traceroute`: Shows the route packets take from source to destination.
  * `netstat`: Displays network connections, routing tables, and interface statistics.

### **1.4 Network Address Translation (NAT)**

* **Concept:** NAT translates private IP addresses to public ones, enabling multiple devices to share a single public IP.
* **Tools:**

  * `iptables`: Can define NAT rules, including SNAT, DNAT, and masquerading.

---

## 2. **Connectivity & Troubleshooting**

### **2.1 Port Scanning / Connectivity Checks**

* **Concept:** Verifying network connectivity, identifying open ports, and testing service availability.
* **Tools:**

  * `nmap`: Powerful network scanner for auditing and vulnerability scanning.
  * `telnet`: Simple tool to test connectivity to specific IPs and ports.

### **2.2 Packet Capture & Analysis**

* **Concept:** Capturing and analyzing packet-level traffic to troubleshoot issues and verify protocol behaviors.
* **Tools:**

  * `tcpdump`: CLI tool for packet capturing.
  * `Wireshark`: GUI-based deep packet inspection and analysis.

### **2.3 Network Performance Testing**

* **Concept:** Measuring bandwidth, latency, and jitter across networks.
* **Tools:**

  * `iperf`: Performance measurement tool for TCP/UDP.
  * `netperf`: Benchmarking tool for throughput and latency.

---

## 3. **Security & Firewalls**

### **3.1 Firewalls & Traffic Rules**

* **Concept:** Restricting or allowing network traffic using predefined rules.
* **Tools:**

  * `ufw`: User-friendly frontend for `iptables` (Ubuntu).
  * `iptables`: Powerful Linux kernel-level firewall rule manager.

### **3.2 VPN & Secure Communication**

* **Concept:** Establish secure communication tunnels between systems across public networks.
* **Tools:**

  * `OpenVPN`: Open-source VPN solution.
  * `WireGuard`: Lightweight and modern VPN protocol.

---

## 4. **Load Balancing & Proxying**

### **4.1 Load Balancing**

* **Concept:** Distributing incoming network traffic across multiple servers.
* **Tools:**

  * `HAProxy`: High-performance TCP/HTTP load balancer.
  * `Nginx`: Also supports HTTP load balancing and reverse proxy.

### **4.2 Reverse Proxy**

* **Concept:** Forwarding client requests to backend servers and returning results transparently.
* **Tools:**

  * `Nginx`: Popular for serving static content and SSL termination.
  * `Traefik`: Dynamic reverse proxy for microservices and containerized apps.

---

## 5. **Service Discovery**

### **5.1 Internal Service Resolution**

* **Concept:** Dynamic discovery and registration of services in distributed systems.
* **Tools:**

  * `Consul`: Service mesh and DNS-based service discovery.
  * `CoreDNS`: DNS server extensible via plugins, used in Kubernetes.

---

## 6. **Container Networking**

### **6.1 Docker Networking**

* **Concept:** Enabling communication between containers and external networks using bridge, overlay, or host networking.
* **Tools:**

  * `docker network`: Manage container network interfaces.
  * `Weave Net`: Overlay network for Docker containers.

### **6.2 Kubernetes Networking**

* **Concept:** Pod-to-pod communication, network policies, and service abstractions within Kubernetes.
* **Tools:**

  * `Cilium`: eBPF-based Kubernetes CNI for performance and security.
  * `Calico`: Policy-driven networking and network security.

---

## 7. **Observability & Monitoring**

### **7.1 Network Metrics Monitoring**

* **Concept:** Tracking network usage, bandwidth, and error rates.
* **Tools:**

  * `Prometheus` + `node_exporter`: Collect and store metrics.
  * `Grafana`: Visualize network trends and anomalies.

### **7.2 Log Management**

* **Concept:** Centralized logging and searchable logs to identify networking issues.
* **Tools:**

  * `Fluent Bit` / `Fluentd`: Log collectors.
  * `Elasticsearch`: Storage and search engine for logs.

### **7.3 Alerting**

* **Concept:** Notify on abnormal network behavior or outages.
* **Tools:**

  * `Alertmanager`: Routing alerts from Prometheus to users.

---

## 8. **Cloud Networking**

### **8.1 VPC & Subnet Configuration**

* **Concept:** Virtual network design and segmentation in cloud environments.
* **Tools:**

  * AWS VPC Console / CLI: Create subnets, route tables, etc.
  * `Terraform`: Define VPC resources as code.

### **8.2 Cloud Load Balancers**

* **Concept:** Distribute traffic in cloud-native environments.
* **Tools:**

  * AWS ALB/NLB: Layer 7 and Layer 4 load balancing.
  * Azure Load Balancer: Managed traffic distribution.

### **8.3 Cloud Firewalls & Security Groups**

* **Concept:** Fine-grained access control for cloud resources.
* **Tools:**

  * AWS Security Groups: Instance-level access control.
  * GCP Firewall Rules: Network-level access restrictions.

---

## 9. **Infrastructure as Code (Networking)**

### **9.1 Defining Network Resources**

* **Concept:** Use of code to provision and manage network resources.
* **Tools:**

  * `Terraform`: Platform-agnostic IaC tool.
  * `Pulumi`: IaC using general-purpose languages.

---

## 10. **Automation & CI/CD for Networking Configs**

### **10.1 Network Config Automation**

* **Concept:** Automating repetitive and critical networking configurations.
* **Tools:**

  * `Ansible`: Agentless automation tool.
  * `Netmiko`: Python library to automate device-level configs.

---

## 11. **Zero Trust Networking**

### **11.1 Micro-segmentation and Policy Enforcement**

* **Concept:** Enforcing least-privilege access and verifying every request.
* **Tools:**

  * `Istio`: Service mesh enforcing secure communication and policies.
  * `OPA`: Policy-as-code tool for fine-grained access control.

---

## 12. **Miscellaneous Tools**

### **12.1 Basic Networking Commands**

* `ping`: Check connectivity.
* `netcat (nc)`: Read/write across network connections.
* `ss`: Show socket statistics.

### **12.2 HTTP Debugging Tools**

* `curl`: Transfer data using various protocols.
* `httpie`: User-friendly command-line HTTP client.

