# 1. Nginx and Web server related knowledge

- [1. Nginx and Web server related knowledge](#1-nginx-and-web-server-related-knowledge)
  - [1.1. **What is a `worker_processes` in Nginx?**](#11-what-is-a-worker_processes-in-nginx)
    - [1.1.1. **How Worker Processes Function:**](#111-how-worker-processes-function)
  - [1.2. **Can Two Worker Processes Be Assigned to the Same CPU Core?**](#12-can-two-worker-processes-be-assigned-to-the-same-cpu-core)
    - [1.2.1. **CPU Core Allocation:**](#121-cpu-core-allocation)
    - [1.2.2. **Explicitly Controlling CPU Affinity:**](#122-explicitly-controlling-cpu-affinity)
    - [1.2.3. **Best Practices:**](#123-best-practices)
  - [1.3. What does `worker_connections` in this case mean? Does it mean a TCP handshake connection?](#13-what-does-worker_connections-in-this-case-mean-does-it-mean-a-tcp-handshake-connection)
    - [1.3.1. **Detailed Breakdown:**](#131-detailed-breakdown)
    - [1.3.2. **Key Takeaways:**](#132-key-takeaways)
  - [1.4. What is the diffrence between `worker_processes` and `worker_connections`?](#14-what-is-the-diffrence-between-worker_processes-and-worker_connections)
    - [1.4.1. **1. `worker_processes auto;`**](#141-1-worker_processes-auto)
      - [1.4.1.1. **Why it matters:**](#1411-why-it-matters)
      - [1.4.1.2. **Auto mode (`auto`) vs. Manual configuration:**](#1412-auto-mode-auto-vs-manual-configuration)
      - [1.4.1.3. **Best practices:**](#1413-best-practices)
    - [1.4.2. **2. `events { worker_connections 1024; }`**](#142-2-events--worker_connections-1024-)
      - [1.4.2.1. **`worker_connections 1024;` Explained:**](#1421-worker_connections-1024-explained)
      - [1.4.2.2. **Real-world example:**](#1422-real-world-example)
      - [1.4.2.3. **Optimizing `worker_connections`:**](#1423-optimizing-worker_connections)
    - [1.4.3. **Putting it all together**](#143-putting-it-all-together)
    - [1.4.4. **What’s next?**](#144-whats-next)
  - [1.5. What does the request rate limiter `limit_req` in Nginx do?](#15-what-does-the-request-rate-limiter-limit_req-in-nginx-do)
    - [1.5.1. **Basic Request Rate Limiting Setup**](#151-basic-request-rate-limiting-setup)
    - [1.5.2. **Explanation**](#152-explanation)
    - [1.5.3. **Real-World Use Cases**](#153-real-world-use-cases)
  - [1.6. What does the connection rate limiter `limit_conn` in Nginx do?](#16-what-does-the-connection-rate-limiter-limit_conn-in-nginx-do)
    - [1.6.1. **How `limit_conn` Works**](#161-how-limit_conn-works)
    - [1.6.2. **Example Configuration**](#162-example-configuration)
    - [1.6.3. **Key Components**](#163-key-components)
    - [1.6.4. **Why Use `limit_conn`?**](#164-why-use-limit_conn)

## 1.1. **What is a `worker_processes` in Nginx?**  
A **worker process** in Nginx is responsible for handling incoming requests and managing connections. Each worker process can execute independently and is designed to efficiently process multiple requests using an **event-driven, asynchronous** model.

### 1.1.1. **How Worker Processes Function:**
- When Nginx starts, it creates **one master process** and multiple **worker processes**.
- The **master process** manages the worker processes—starting them, stopping them, and handling configuration updates.
- Worker processes do the actual work of processing client connections, serving files, proxying requests, etc.
- Each worker process operates independently and does not share memory with other worker processes.


## 1.2. **Can Two Worker Processes Be Assigned to the Same CPU Core?**  
By default, Nginx attempts to **bind worker processes to different CPU cores** for optimal performance. However, two worker processes **can** be assigned to the same CPU core **if there are more workers than available CPU cores**.

### 1.2.1. **CPU Core Allocation:**
- On **multi-core systems**, Nginx distributes worker processes across cores for efficiency.
- On **single-core systems** or systems with fewer cores than workers, multiple worker processes will be assigned to the same core.

### 1.2.2. **Explicitly Controlling CPU Affinity:**
You can manually control how worker processes are mapped to CPU cores using the `worker_cpu_affinity` directive:
```nginx
worker_processes 4;
worker_cpu_affinity 0100 0010 0001 1000;
```
Each binary number (`0100`, `0010`, etc.) maps a worker process to a CPU core.

### 1.2.3. **Best Practices:**
- If your server has **4 CPU cores**, setting `worker_processes 4;` allows each worker to run on a separate core.
- If your server has **2 CPU cores**, but you configure `worker_processes 4;`, then two worker processes **will share** a core.



## 1.3. What does `worker_connections` in this case mean? Does it mean a TCP handshake connection?
### 1.3.1. **Detailed Breakdown:**
1. **TCP Handshake & Connection:**  
   - Every client that wants to communicate with the Nginx server must first establish a TCP connection.  
   - This follows the standard **three-way handshake** process:
     - **SYN:** The client sends a SYN (synchronize) request to initiate communication.
     - **SYN-ACK:** Nginx responds with SYN-ACK, acknowledging the request.
     - **ACK:** The client replies with ACK, completing the handshake.
   - Once the handshake is done, the connection is **established**, and the client can send HTTP requests.

2. **Impact on `worker_connections`:**  
   - Nginx manages incoming client connections via **worker processes**.
   - `worker_connections 1024;` defines **how many concurrent TCP connections** each worker process can handle at a time.
   - If a worker process reaches its connection limit, new requests might be **queued** or **dropped**, depending on the system configuration.

3. **Connection Types in Nginx:**  
   - **Keep-alive connections:**  
     - Instead of opening a new TCP connection for every request, clients may use **persistent connections** (HTTP Keep-Alive).  
     - This reduces latency and improves performance.  
   - **Idle connections:**  
     - If a connection remains **idle**, Nginx may terminate it based on timeouts.  
   - **Active connections:**  
     - Connections actively sending/receiving data remain **open** until the client or server decides to close them.

### 1.3.2. **Key Takeaways:**
- Each connection is a **TCP connection**, initiated via handshake.
- The `worker_connections` setting defines **how many simultaneous client connections** a worker process can handle.
- Managing connections efficiently improves performance, especially under high traffic.


## 1.4. What is the diffrence between `worker_processes` and `worker_connections`?
### 1.4.1. **1. `worker_processes auto;`**
This directive defines the number of worker processes that Nginx will spawn to handle requests.

#### 1.4.1.1. **Why it matters:**
- Nginx operates on an **event-driven** model, meaning it uses multiple processes efficiently.
- The number of worker processes directly affects performance, especially for high-traffic websites.

#### 1.4.1.2. **Auto mode (`auto`) vs. Manual configuration:**
- `auto` lets Nginx decide the optimal number of worker processes based on available CPU cores.
- You can also manually specify a number (`worker_processes 4;`) for fine-tuned control.

#### 1.4.1.3. **Best practices:**
- Keeping `auto` is recommended for modern systems because it ensures **optimal CPU utilization**.
- If manually setting, it’s common to match the **number of CPU cores** to the number of worker processes.

---

### 1.4.2. **2. `events { worker_connections 1024; }`**
This section configures the event model that handles connections.

#### 1.4.2.1. **`worker_connections 1024;` Explained:**
- Each **worker process** can handle up to **1024 simultaneous connections**.
- If you have multiple worker processes, the total connections handled = `worker_processes × worker_connections`.

#### 1.4.2.2. **Real-world example:**
Imagine you have:
- 4 worker processes (`worker_processes 4;`)
- Each process can handle 1024 connections (`worker_connections 1024;`)

Your Nginx can then theoretically handle **4 × 1024 = 4096 concurrent connections**.

#### 1.4.2.3. **Optimizing `worker_connections`:**
- If running a **high-traffic website**, increasing this number (e.g., `worker_connections 2048;`) can help.
- Make sure your OS allows sufficient **file descriptors** (`ulimit -n`) to support this setting.

---

### 1.4.3. **Putting it all together**
These settings define how Nginx handles concurrent requests efficiently:
1. **Worker Processes (`worker_processes`)** controls the number of active processes.
2. **Worker Connections (`worker_connections`)** determines how many connections each process can manage.

### 1.4.4. **What’s next?**
- You can optimize by adjusting these values based on traffic and server capacity.
- For advanced performance tuning, consider tweaking **event models** (like `epoll` for Linux).

## 1.5. What does the request rate limiter `limit_req` in Nginx do?
### 1.5.1. **Basic Request Rate Limiting Setup**
Here's a common **request rate limiter** that restricts each client IP to **5 requests per second**, allowing temporary bursts:

```nginx
http {
    limit_req_zone $binary_remote_addr zone=req_limit:10m rate=5r/s;

    server {
        listen 80;
        server_name example.com;

        location /api/ {
            limit_req zone=req_limit burst=10 nodelay;
        }
    }
}
```

### 1.5.2. **Explanation**
- **`limit_req_zone $binary_remote_addr zone=req_limit:10m rate=5r/s;`**
  - Creates a zone (`req_limit`) to track client IPs.
  - Limits each IP to **5 requests per second** (`rate=5r/s`).
  
- **`limit_req zone=req_limit burst=10 nodelay;`**
  - Allows bursts up to **10 requests** before throttling starts.
  - `nodelay` means excess requests are immediately rejected instead of queued.

### 1.5.3. **Real-World Use Cases**
1. **API Protection** – Prevent excessive requests from a single user overloading an API.
2. **Brute-Force Prevention** – Limit login attempts to reduce password-guessing attacks.
3. **Bot & Scraper Control** – Prevent aggressive web scrapers from slowing down the site.limit_conn)
4. **Fair Resource Distribution** – Ensure all users get reasonable access without disruptions.
5. **DoS Attack Mitigation** – Helps prevent low-level denial-of-service attempts.

## 1.6. What does the connection rate limiter `limit_conn` in Nginx do?
**`limit_conn`** in Nginx is used to **restrict the number of simultaneous connections** per client. This is crucial for protecting servers from resource exhaustion, preventing abuse, and ensuring fair usage.

### 1.6.1. **How `limit_conn` Works**
- It limits the **maximum number of concurrent connections** from a single user or IP address.
- Often used to prevent excessive resource consumption, such as **too many open connections** from a single IP.
- Can be applied **globally** (for all requests) or **within specific locations**.

### 1.6.2. **Example Configuration**
```nginx
http {
    # Define connection limit zone based on client IP
    limit_conn_zone $binary_remote_addr zone=conn_limit:10m;

    server {
        listen 443 ssl;
        server_name example.com;

        ssl_certificate /etc/nginx/ssl/example.crt;
        ssl_certificate_key /etc/nginx/ssl/example.key;

        location / {
            limit_conn conn_limit 10;  # Restrict each client to 10 connections
            root /var/www/html;
            index index.html;
        }
    }
}
```

### 1.6.3. **Key Components**
- **`limit_conn_zone $binary_remote_addr zone=conn_limit:10m;`**
  - Creates a memory zone (`conn_limit`) to track client IPs.
  - `$binary_remote_addr` ensures efficient IP storage.

- **`limit_conn conn_limit 10;`**
  - Limits each client **IP** to **10 concurrent connections**.

### 1.6.4. **Why Use `limit_conn`?**
✅ Prevent **resource exhaustion** (excessive open connections).  
✅ Protect against **slow-rate DoS attacks** (ex. too many concurrent requests).  
✅ Ensure **fair resource usage** among users.  
✅ Stop **abusive bots & scrapers** from overwhelming your server.  

