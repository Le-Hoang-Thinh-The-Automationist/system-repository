

# 1. Bind9 and DNS server related knowledge
- [1. Bind9 and DNS server related knowledge](#1-bind9-and-dns-server-related-knowledge)
  - [1.1. What is DNS Query?](#11-what-is-dns-query)
    - [1.1.1. **Types of DNS Queries**](#111-types-of-dns-queries)
    - [1.1.2. **How a DNS Query Works (Step-by-Step)**](#112-how-a-dns-query-works-step-by-step)
  - [1.2. What does the `named.conf.options` file contains?](#12-what-does-the-namedconfoptions-file-contains)
    - [1.2.1. **1. `directory "/var/cache/bind";`**](#121-1-directory-varcachebind)
    - [1.2.2. **2. `listen-on port 53 { any; };`**](#122-2-listen-on-port-53--any-)
    - [1.2.3. **3. `listen-on-v6 { any; };`**](#123-3-listen-on-v6--any-)
    - [1.2.4. **4. `allow-query { localhost; 192.168.1.0/24; };`**](#124-4-allow-query--localhost-1921681024-)
    - [1.2.5. **5. `forwarders { 8.8.8.8; 8.8.4.4; };`**](#125-5-forwarders--8888-8844-)
    - [1.2.6. **6. `dnssec-validation auto;`**](#126-6-dnssec-validation-auto)
    - [1.2.7. **7. `recursion yes;`**](#127-7-recursion-yes)
    - [1.2.8. **What This Configuration Does**](#128-what-this-configuration-does)
  - [1.3. What does the `named.conf.local` file contains?](#13-what-does-the-namedconflocal-file-contains)
  - [1.4. What is the different between `named.conf.options` and `named.conf.local`?](#14-what-is-the-different-between-namedconfoptions-and-namedconflocal)
    - [1.4.1. **1. `named.conf.options`**](#141-1-namedconfoptions)
      - [1.4.1.1. **Example (`named.conf.options`):**](#1411-example-namedconfoptions)
    - [1.4.2. **2. `named.conf.local`**](#142-2-namedconflocal)
      - [1.4.2.1. **Example (`named.conf.local`):**](#1421-example-namedconflocal)
    - [1.4.3. **Summary of Differences**](#143-summary-of-differences)

## 1.1. What is DNS Query?
A **DNS query** (or **DNS request**) is when a device (like your computer, phone, or server) asks a **DNS server** to find the IP address of a domain name. Essentially, it's how your browser translates **human-readable addresses** (like `example.com`) into machine-understandable **IP addresses** (`192.168.1.10`).

### 1.1.1. **Types of DNS Queries**
1. **Recursive Query**  
   - The client (your device) asks a **recursive resolver** to find the IP address.  
   - The resolver either **answers directly** (if cached) or **asks other DNS servers** until it finds the answer.  
   - Used by default in most internet browsing requests.

2. **Iterative Query**  
   - The DNS resolver **does not search for the answer itself** but instead **points the client** to the next DNS server.  
   - The client may need to ask multiple DNS servers before getting an answer.

3. **Non-Recursive Query**  
   - If the DNS server already **knows the answer** (from cache or authoritative records), it responds instantly.  
   - Used for frequently accessed domains.

### 1.1.2. **How a DNS Query Works (Step-by-Step)**
1. You type `example.com` into your browser.
2. Your device sends a **DNS query** to a resolver (usually your **ISP's DNS server**).
3. The resolver checks its **cache**:
   - If it **has the answer**, it replies instantly.
   - If not, it asks a **root DNS server** (which directs it to the right location).
4. The resolver finds the **authoritative DNS server** for `example.com`.
5. That authoritative server responds with the **correct IP address**.
6. Your browser uses that **IP address** to connect to `example.com`.


## 1.2. What does the `named.conf.options` file contains?

```conf
options {
    directory "/var/cache/bind";

    listen-on port 53 { any; };

    allow-query { 
        localhost; 
        192.168.1.0/24; 
    };

    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    dnssec-validation auto;

    recursion yes;
};
```
Certainly! Let's break down what each directive in this **BIND9 configuration file (`named.conf.options`)** does:

### 1.2.1. **1. `directory "/var/cache/bind";`**
- Sets the **working directory** for BIND9, where it stores its cache, logs, and temporary data.

### 1.2.2. **2. `listen-on port 53 { any; };`**
- Tells BIND to **listen** for **DNS queries** on **port 53**, which is the default DNS port.
- `{ any; }` means it will accept queries from **any network interface** on the machine.

### 1.2.3. **3. `listen-on-v6 { any; };`**
- Allows BIND to **listen** on **IPv6 interfaces**, accepting queries from any IPv6-connected devices.

### 1.2.4. **4. `allow-query { localhost; 192.168.1.0/24; };`**
- Restricts which clients can **query** the DNS server.
- `localhost;` → Allows only local queries from the same machine.
- `192.168.1.0/24;` → Allows queries from the **192.168.1.x subnet**, meaning **internal clients can use this DNS server**.

### 1.2.5. **5. `forwarders { 8.8.8.8; 8.8.4.4; };`**
- If BIND **can't resolve** a query locally, it **forwards** the request to external DNS resolvers.
- `8.8.8.8` and `8.8.4.4` are **Google's public DNS servers**, ensuring reliable resolution.

### 1.2.6. **6. `dnssec-validation auto;`**
- Enables **DNSSEC (DNS Security Extensions)** validation automatically.
- Protects against **DNS spoofing and tampering** by verifying DNS responses with cryptographic signatures.

### 1.2.7. **7. `recursion yes;`**
- Enables **recursive DNS resolution**.
- If a DNS query **isn't locally known**, BIND will **search external DNS servers** for the answer.

### 1.2.8. **What This Configuration Does**
- **Runs BIND as a caching and recursive DNS resolver**.
- **Accepts queries only from localhost and internal clients** (`192.168.1.0/24`).
- **Forwards unresolved requests** to Google's **DNS servers** (`8.8.8.8`, `8.8.4.4`).
- **Supports DNSSEC security features** for safer DNS lookups.
- **Listens on both IPv4 and IPv6**, ensuring compatibility.

## 1.3. What does the `named.conf.local` file contains?



## 1.4. What is the different between `named.conf.options` and `named.conf.local`?

The difference between **`named.conf.options`** and **`named.conf.local`** in BIND9 lies in their roles and the type of configurations they hold:

### 1.4.1. **1. `named.conf.options`**  
- Defines **global settings** and **server-wide options** for BIND9.
- Used to configure **DNS forwarding, recursion, security policies, and logging**.
- Example settings:
  - **Forwarders** (external DNS resolvers like `8.8.8.8`)
  - **Allowed query sources** (`allow-query`)
  - **Listening interfaces** (`listen-on`)
  - **DNSSEC validation**

#### 1.4.1.1. **Example (`named.conf.options`):**
```conf
options {
    directory "/var/cache/bind";

    // Listen on all interfaces
    listen-on port 53 { any; };
    listen-on-v6 { any; };

    // Allow queries from local network
    allow-query { localhost; 192.168.1.0/24; };

    // Forward DNS queries to external resolvers
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    dnssec-validation auto;

    recursion yes;
};
```

### 1.4.2. **2. `named.conf.local`**  
- Defines **custom DNS zones** that the server will host.
- Used for **setting up authoritative zones** (forward & reverse lookup zones).
- Example settings:
  - **Primary (master) and secondary (slave) zones**
  - **Zone file locations**
  - **Zone transfer permissions**

#### 1.4.2.1. **Example (`named.conf.local`):**
```conf
zone "example.com" {
    type master;
    file "/etc/bind/db.example.com";
};

zone "1.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192";
};
```

### 1.4.3. **Summary of Differences**
| **File**              | **Purpose**                                      | **Example Settings** |
|----------------------|------------------------------------------------|---------------------|
| `named.conf.options` | Global settings for BIND9 **behavior & queries** | Forwarders, recursion, security, logging |
| `named.conf.local`   | Defines **specific DNS zones** hosted by the server | Zone definitions, master/slave setup |

