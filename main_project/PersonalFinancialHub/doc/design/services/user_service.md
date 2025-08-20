# Architecture with Spring Boot


```
[ Client (Web/Mobile) ]
        |
        v
[ API Gateway / Reverse Proxy ] ← Nginx / Spring Cloud Gateway
        |
        v
[ Spring Boot Identity Service ]
  ├── User Registration (w/ Email Verification)
  ├── Authentication (JWT, Refresh, MFA)
  ├── Profile Management (Encrypted PII)
  ├── Consent & GDPR Features
  ├── Audit Logging
        |
        v
[ PostgreSQL Database ] ← (Users, Tokens, Audit logs)
        |
        v
[ Optional: Object Storage ] ← (for Data Export/Backups)
```

---

# 🔹 Technology Stack (Spring Boot–friendly, FSI-aligned, Beginner-Approachable)

* **Backend Framework:**

  * **Spring Boot** (2.7+ or 3.x for Jakarta EE)
  * Starter dependencies: `spring-boot-starter-web`, `spring-boot-starter-security`, `spring-boot-starter-data-jpa`

* **Authentication & Security:**

  * **Spring Security** (custom JWT authentication filter)
  * **Spring Security OAuth2 Resource Server** (if future OIDC integration needed)
  * MFA (TOTP) → use `GoogleAuthenticator` via `com.warrenstrange:googleauth`

* **Database:** PostgreSQL with:

  * `pgcrypto` extension for AES-256 encryption at rest
  * JPA/Hibernate entities for `users` and `audit_log`

* **Password Hashing:** `BCryptPasswordEncoder` (Spring Security built-in, FSI compliant)

* **Token Management:**

  * **JWT (15 min expiry)** for access tokens
  * Refresh tokens stored in DB (rotated on use)

* **Audit Logging:**

  * Spring AOP + Event Listeners → log all login, logout, password reset events into `user_audit_log`

* **Session & Lockout Handling:**

  * Failed attempts tracked in DB
  * Lockout rule enforced in authentication provider

* **Cost Optimization:**

  * Run on Docker Compose (Spring Boot + Postgres)
  * Free-tier cloud deploy (Heroku, Render, Railway, Fly.io)

---

# 🚀 MVP Scope (Spring Boot)

1. **Registration API** (Email + Password + Terms acceptance logged in audit table)
2. **Email Verification** (send token via SMTP — can use free service like MailHog locally)
3. **Authentication** (JWT short-lived + Refresh Token w/ rotation)
4. **MFA (TOTP)** setup + validation via Google Authenticator
5. **Failed Login Handling** (after 5 failures → 30 min lockout)
6. **Profile API** (PII stored encrypted with `pgcrypto`)
7. **Audit Logging** (Spring events → DB table write)
8. **Account Deactivation + Soft Delete** (GDPR right-to-be-forgotten)

---

# ⭐ Important Spring Boot–Specific Highlights

✅ **Spring Security is central**: configure JWT filters, password policies, and MFA validation.
✅ **Use JPA Entities for compliance**: enforce column encryption for sensitive fields.
✅ **Audit logging with Spring Events**: capture auth-related events automatically.
✅ **Cost-optimize SMTP**: for MVP, use MailHog/GreenMail locally instead of paid SMTP.
✅ **Deployment**: single Spring Boot JAR containerized via Docker → deployable anywhere.

---

# ✅ Acceptance Criteria (MVP, FSI-aligned, Spring Boot)

### **Functional**

1. Registration requires strong password + email verification.
2. MFA setup available and enforced on login.
3. Login returns JWT (15m) + refresh token (stored & rotated).
4. Account locked after 5 failed logins (30 min).
5. Password reset flow via secure token link.
6. Profile updates encrypted and retrievable only with JWT.
7. Audit log records all actions with user, IP, timestamp.
8. Account deactivation and data export implemented.

### **Non-Functional**

1. All sensitive data (PII, passwords, refresh tokens) encrypted or hashed.
2. Session idle timeout = 15 min.
3. Audit log immutable (insert-only, no updates).
4. Service runs on Postgres + Spring Boot locally with Docker.
5. HTTPS enforced (via Nginx reverse proxy).
6. Documentation available for API usage & developer setup.

