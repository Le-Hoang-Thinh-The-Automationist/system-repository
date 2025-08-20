# 🏗️ Updated Architecture with Spring Boot (Transaction Service)

```
[ Client (Web/Mobile) ]
        |
        v
[ API Gateway / Reverse Proxy ] ← Nginx / Spring Cloud Gateway
        |
        v
[ Spring Boot Transaction Service ]
  ├── Transaction Operations (CRUD, Bulk Import, Reconciliation)
  ├── Event Sourcing (Immutable log in transaction_events)
  ├── Double-Entry Accounting (Ledger model)
  ├── Validation (business rules, anti-fraud)
  ├── Audit Logging
  ├── Regulatory Exports
        |
        v
[ PostgreSQL Database ]
  ├── transaction_events (immutable ledger)
  ├── transactions (current view)
  ├── transaction_categories (hierarchical categories)
```

---

# 🔹 Technology Stack (Spring Boot + FSI Optimized)

* **Backend Framework:** Spring Boot 3.x

  * `spring-boot-starter-web`
  * `spring-boot-starter-data-jpa`
  * `spring-boot-starter-security`
  * `spring-boot-starter-validation`

* **Event Sourcing & Versioning:**

  * Store all immutable changes in `transaction_events`
  * Materialize into `transactions` table

* **Double-Entry Bookkeeping:**

  * Represent with debit/credit entries (extend schema later)
  * MVP: enforce at least two opposing entries per transaction

* **Data Validation:**

  * Bean Validation (`@Valid`, `@DecimalMin`, `@Pattern`, etc.)
  * Custom validators for currency/date/business rules

* **Audit Logging:**

  * Spring AOP or TransactionEventPublisher → writes to `transaction_events`
  * Store hashes (`previous_version_hash` + `current_version_hash`) for integrity

* **Security & Access Control:**

  * Spring Security → user-scoped transactions only
  * Row-level security via `user_id` checks

* **Encryption:**

  * Sensitive fields (merchant, description) encrypted at rest using `pgcrypto`

* **Bulk Import:**

  * Use **Spring Batch** (free, standard in Spring Boot) to handle CSV/bank files

* **Cost Optimization:**

  * PostgreSQL (free, ACID compliant)
  * Spring Boot (open source)
  * Deploy via Docker (local → free-tier cloud like Render, Fly.io, Railway)

---

# 🚀 MVP Scope (Spring Boot Transaction Service)

1. **Create Transaction** (income/expense/transfer) → persists in `transaction_events` and materializes into `transactions`.
2. **Update Transaction** → immutable event written (`UPDATED`), new version in `transactions`.
3. **Delete Transaction** → soft delete event (`DELETED`), marked in `transactions`.
4. **Categorization** → hierarchical categories, system + custom.
5. **Bulk Import** → CSV upload processed with Spring Batch.
6. **Validation Rules** →

   * No negative amounts for income
   * Currency must be valid ISO 4217
   * Dates cannot be future beyond threshold
   * Duplicate detection (hash check)
7. **Audit & Compliance** →

   * Full event log (who, what, when, why)
   * Transaction versioning via `version` column
   * Hash integrity checks for tamper detection

---

# ⭐ Important Spring Boot–Specific Highlights

✅ **Event Sourcing is key**: never update transactions directly, always append events.
✅ **Double-entry foundation**: ensure every financial entry balances out.
✅ **Regulatory Readiness**: keep data 7+ years, export audit trail easily.
✅ **Security**: authorization checks per user, encrypt merchant/PII.
✅ **Spring Batch**: for bulk import (bank files/CSV).
✅ **API Input Validation**: use `javax.validation` annotations for safety.

---

# ✅ Acceptance Criteria (MVP, FSI-aligned, Spring Boot)

### **Functional**

1. User can create, update, delete transactions.
2. All changes generate immutable events in `transaction_events`.
3. Current state is reflected in `transactions` view table.
4. Categories can be system-defined or user-defined.
5. Bulk import via CSV works with validation.
6. Transaction validation rules enforced (amount, currency, date, duplicate).
7. Audit log available per transaction (`/audit/{transactionId}`).
8. Transactions are soft-deleted, not physically removed.

### **Non-Functional**

1. Every change is recorded with event hash for integrity.
2. Double-entry enforced (must balance debit/credit).
3. Sensitive fields encrypted in DB.
4. User can only access own transactions (Spring Security).
5. Audit logs immutable (append-only).
6. Service runs with Spring Boot + Postgres locally in Docker.
7. Data retention policy configurable (default 7 years).
8. Bulk import scales to at least 10k records.

---

👉 Would you like me to **extend the schema** with a simple **double-entry ledger table** (debits/credits per account) so that even the MVP has a proper accounting foundation, or should we keep it at the simplified `transactions` + `transaction_events` level for now?
