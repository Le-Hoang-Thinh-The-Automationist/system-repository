# Configuration Management - Ansible

## What is the difference between `tasks` and `handlers`?
In an **Ansible playbook**, **tasks** and **handlers** define the automation steps:

### **🔹 Tasks**
Tasks are the **main actions** executed in a playbook. They contain instructions like installing packages, managing services, configuring files, or running commands.

✅ **Example Task: Installing Apache**
```yaml
- name: Install Apache
  apt:
    name: apache2
    state: present
```
- Runs `apt install apache2` on Debian-based systems.
- Ensures Apache is **installed** (if missing, it installs it).

---

### **🔹 Handlers**
Handlers are **special tasks** that run **only if triggered** by other tasks. They are commonly used to restart services after configuration changes.

✅ **Example Handler: Restart Apache**
```yaml
- name: Restart Apache
  service:
    name: apache2
    state: restarted
```
- Only runs when called via `notify`.
- Used after updates that require a restart.

✅ **Example Usage in a Task**
```yaml
- name: Install Apache
  apt:
    name: apache2
    state: present
  notify: Restart Apache  # This triggers the handler
```
