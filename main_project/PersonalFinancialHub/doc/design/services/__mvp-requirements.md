# FSI-Compliant MVP Microservices Specification

## 🏦 Personal Financial Hub - MVP with FSI Standards

### 📋 Core Business Requirements

**Primary Goal**: Create a secure, compliant personal finance tracking system that demonstrates FSI-grade architecture patterns while maintaining MVP simplicity.

**Target Users**: Individual users managing personal finances
**Compliance Level**: Entry-level FSI standards (suitable for portfolio/learning)
**Architecture**: Event-driven microservices with strong consistency for financial data

---

## 🔐 1. User Identity & Access Service

### **Core MVP Features**
```yaml
User Registration:
├── Email-based registration with verification
├── Strong password requirements (FSI standard)
├── Multi-factor authentication setup (TOTP)
├── KYC-lite: Basic identity verification
└── Terms & conditions acceptance with audit trail

User Authentication:
├── JWT-based authentication with short expiry (15 minutes)
├── Refresh token mechanism with rotation
├── Session management with concurrent session limits
├── Failed login attempt monitoring and lockout
└── Password reset with secure token mechanism

Profile Management:
├── Personal information (encrypted PII)
├── Notification preferences
├── Security settings management
├── Account deactivation/closure process
└── Data export capability (GDPR compliance)
```

### **FSI Compliance Features**
```yaml
Security Requirements:
├── Password Policy: 12+ chars, complexity requirements
├── Account Lockout: 5 failed attempts = 30min lockout
├── Session Timeout: Idle timeout after 15 minutes
├── Audit Logging: All authentication events logged
└── Data Encryption: PII encrypted at rest (AES-256)

Regulatory Compliance:
├── GDPR: Right to be forgotten, data portability
├── Data Retention: Configurable retention policies
├── Consent Management: Granular permission tracking
├── Access Logging: Who accessed what, when
└── Privacy Controls: Data usage transparency
```

### **API Endpoints**
```http
POST /api/v1/users/register
POST /api/v1/users/login
POST /api/v1/users/logout
POST /api/v1/users/refresh-token
GET  /api/v1/users/profile
PUT  /api/v1/users/profile
POST /api/v1/users/change-password
POST /api/v1/users/reset-password
POST /api/v1/users/verify-mfa
DELETE /api/v1/users/account
```

### **Database Schema (PostgreSQL)**
```sql
-- Users table with encryption
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    encrypted_pii TEXT NOT NULL, -- JSON with encrypted personal data
    mfa_secret VARCHAR(255),
    account_status VARCHAR(20) DEFAULT 'ACTIVE',
    failed_login_attempts INTEGER DEFAULT 0,
    last_login_attempt TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);

-- Audit trail for all user actions
CREATE TABLE user_audit_log (
    audit_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    ip_address INET,
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    additional_data JSONB
);
```

---

## 💰 2. Transaction Management Service

### **Core MVP Features**
```yaml
Transaction Operations:
├── Create transaction (income/expense)
├── Update transaction (with approval workflow)
├── Delete transaction (soft delete with audit)
├── Categorize transactions (predefined + custom)
└── Bulk import from CSV/bank files

Transaction Properties:
├── Amount (decimal precision for currency)
├── Currency (multi-currency support)
├── Category (hierarchical categories)
├── Description and notes
├── Transaction date vs booking date
├── Merchant/counterparty information
├── Payment method (cash, card, bank transfer)
└── Location data (optional)

Data Validation:
├── Amount validation (no negative expenses as positive)
├── Date validation (future date restrictions)
├── Currency validation against supported list
├── Duplicate transaction detection
└── Business rule validation (daily limits, etc.)
```

### **FSI Compliance Features**
```yaml
Financial Data Integrity:
├── Immutable Transaction Log: Original records never modified
├── Double-Entry Bookkeeping: Every transaction affects 2+ accounts
├── Reconciliation Support: Match against bank statements  
├── Transaction Versioning: Track all changes with reasons
└── Atomic Operations: All-or-nothing transaction processing

Audit & Compliance:
├── Complete Audit Trail: Who, what, when, why for every change
├── Data Integrity Checks: Checksums and validation
├── Regulatory Reporting: Export capabilities for authorities
├── Data Retention: 7-year retention for financial records
└── Anti-Money Laundering: Basic pattern detection

Security Controls:
├── Authorization: User can only access own transactions
├── Data Encryption: Sensitive fields encrypted at rest
├── API Rate Limiting: Prevent abuse and DOS attacks
├── Input Sanitization: Prevent injection attacks
└── Transaction Signing: Cryptographic integrity verification
```

### **API Endpoints**
```http
POST /api/v1/transactions
GET  /api/v1/transactions?page=1&limit=50&category=food
GET  /api/v1/transactions/{transactionId}
PUT  /api/v1/transactions/{transactionId}
DELETE /api/v1/transactions/{transactionId}
POST /api/v1/transactions/bulk-import
GET  /api/v1/transactions/categories
POST /api/v1/transactions/reconcile
GET  /api/v1/transactions/audit/{transactionId}
```

### **Database Schema (PostgreSQL)**
```sql
-- Immutable transaction log (event sourcing pattern)
CREATE TABLE transaction_events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    transaction_id UUID NOT NULL,
    event_type VARCHAR(50) NOT NULL, -- CREATED, UPDATED, DELETED
    event_data JSONB NOT NULL,
    previous_version_hash VARCHAR(64),
    current_version_hash VARCHAR(64) NOT NULL,
    created_by UUID NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Current transaction view (materialized from events)
CREATE TABLE transactions (
    transaction_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    amount DECIMAL(15,4) NOT NULL,
    currency CHAR(3) DEFAULT 'USD',
    transaction_type VARCHAR(20) NOT NULL, -- INCOME, EXPENSE, TRANSFER
    category_id UUID,
    description VARCHAR(500),
    merchant VARCHAR(255),
    transaction_date DATE NOT NULL,
    booking_date DATE DEFAULT CURRENT_DATE,
    payment_method VARCHAR(50),
    status VARCHAR(20) DEFAULT 'POSTED', -- PENDING, POSTED, CANCELLED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    version INTEGER DEFAULT 1,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Categories with hierarchical structure
CREATE TABLE transaction_categories (
    category_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID, -- NULL for system categories, USER_ID for custom
    parent_category_id UUID,
    category_name VARCHAR(100) NOT NULL,
    category_type VARCHAR(20) NOT NULL, -- INCOME, EXPENSE, TRANSFER
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📊 3. Financial Analytics Service

### **Core MVP Features**
```yaml
Account Balances:
├── Current balance calculation (real-time)
├── Available balance (pending transactions)
├── Historical balance tracking
├── Multi-currency balance support
└── Balance alerts and notifications

Monthly Reporting:
├── Income vs Expenses summary
├── Category-wise spending breakdown
├── Month-over-month comparisons
├── Top merchants/spending patterns
└── Budget variance reporting

Trend Analysis:
├── Spending trends over time
├── Seasonal spending patterns
├── Category growth/decline analysis
├── Cash flow projections (basic)
└── Financial health score calculation

Data Visualization:
├── Charts and graphs data APIs
├── Spending heatmaps
├── Category pie charts
├── Balance trend lines
└── Export capabilities (PDF/Excel)
```

### **FSI Compliance Features**
```yaml
Data Accuracy & Integrity:
├── Real-time Balance Calculation: No stale data
├── Reconciliation Reports: Match calculated vs actual
├── Data Quality Metrics: Track accuracy and completeness
├── Historical Data Preservation: Maintain calculation history
└── Audit Trail: Track all analytical computations

Regulatory Reporting:
├── Transaction Reporting: Structured data for regulators
├── Pattern Detection: Unusual activity identification
├── Compliance Dashboards: Risk and compliance metrics
├── Data Export: Regulatory-friendly formats
└── Retention Compliance: Meet data retention requirements

Performance & Scalability:
├── Caching Strategy: Pre-calculated common analytics
├── Async Processing: Heavy computations in background
├── Data Aggregation: Efficient summary calculations
├── API Performance: Sub-second response times
└── Batch Processing: Handle large datasets efficiently
```

### **API Endpoints**
```http
GET /api/v1/analytics/balance/current
GET /api/v1/analytics/balance/history?period=6months
GET /api/v1/analytics/summary/monthly?year=2025&month=8
GET /api/v1/analytics/categories/breakdown?period=3months
GET /api/v1/analytics/trends/spending?category=all
GET /api/v1/analytics/cashflow/projection?months=6
GET /api/v1/analytics/reports/export?format=pdf&type=monthly
POST /api/v1/analytics/alerts/setup
```

### **Database Schema (PostgreSQL)**
```sql
-- Account balances with versioning
CREATE TABLE account_balances (
    balance_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    currency CHAR(3) NOT NULL,
    current_balance DECIMAL(15,4) NOT NULL,
    available_balance DECIMAL(15,4) NOT NULL,
    last_transaction_id UUID,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    version INTEGER DEFAULT 1
);

-- Pre-calculated analytics for performance
CREATE TABLE monthly_summaries (
    summary_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    total_income DECIMAL(15,4) DEFAULT 0,
    total_expenses DECIMAL(15,4) DEFAULT 0,
    net_cash_flow DECIMAL(15,4) DEFAULT 0,
    transaction_count INTEGER DEFAULT 0,
    top_category JSONB, -- {category_id, amount, percentage}
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, year, month)
);

-- Category analytics
CREATE TABLE category_analytics (
    analytics_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    category_id UUID NOT NULL,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_amount DECIMAL(15,4) NOT NULL,
    transaction_count INTEGER NOT NULL,
    average_amount DECIMAL(15,4) NOT NULL,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📬 4. Notification & Communication Service

### **Core MVP Features**
```yaml
Notification Types:
├── Email notifications (transactional)
├── In-app notifications
├── SMS notifications (high-priority only)
├── Push notifications (mobile-ready)
└── Webhook notifications (API integrations)

Notification Triggers:
├── Transaction created/updated/deleted
├── Large transaction alerts (>$500)
├── Monthly spending summary
├── Budget limit warnings
├── Security alerts (login from new device)
├── Account balance low warnings
└── System maintenance notifications

Delivery Management:
├── User preference management
├── Notification scheduling
├── Delivery status tracking
├── Failed delivery retry logic
└── Unsubscribe management
```

### **FSI Compliance Features**
```yaml
Communication Security:
├── Encrypted Communications: TLS 1.3 for all channels
├── PII Protection: No sensitive data in notifications
├── Authentication: Verify recipient identity
├── Audit Trail: Log all communications sent
└── Data Minimization: Only necessary information shared

Regulatory Compliance:
├── Opt-in Consent: Explicit consent for marketing
├── Communication Records: Maintain delivery records
├── Privacy Controls: Granular notification preferences
├── Regulatory Notifications: Mandatory compliance notices
└── Data Breach Notifications: Incident communication protocols
```

### **API Endpoints**
```http
POST /api/v1/notifications/send
GET  /api/v1/notifications/preferences
PUT  /api/v1/notifications/preferences
GET  /api/v1/notifications/history?type=email
POST /api/v1/notifications/test
PUT  /api/v1/notifications/mark-read/{notificationId}
```

---

## 🔄 5. Event Processing & Integration Hub

### **Core MVP Features**
```yaml
Event Management:
├── Event publishing (Kafka/Redis Streams)
├── Event consumption and processing
├── Event ordering and deduplication
├── Event replay capabilities
└── Dead letter queue handling

Integration Patterns:
├── Saga orchestration for distributed transactions
├── Event sourcing for audit trails
├── CQRS for read/write separation
├── Outbox pattern for reliable publishing
└── Circuit breaker for external services

Event Types:
├── user.registered, user.updated, user.deleted
├── transaction.created, transaction.updated, transaction.deleted
├── balance.updated, balance.reconciled
├── alert.triggered, notification.sent
└── audit.logged, compliance.checked
```

### **FSI Compliance Features**
```yaml
Event Integrity:
├── Event Signing: Cryptographic verification
├── Event Ordering: Guaranteed sequential processing
├── Event Durability: Persistent storage with backups
├── Event Immutability: Events never modified, only appended
└── Event Replay: Ability to rebuild system state

Audit & Monitoring:
├── Complete Event Audit: Every event logged and tracked
├── Event Processing Metrics: Performance and error tracking
├── Data Lineage: Track data flow through events
├── Compliance Events: Regulatory requirement tracking
└── Event Retention: Meet regulatory retention requirements
```

---

## 🏗️ Cross-Service Architecture Patterns

### **Data Consistency**
```yaml
Consistency Patterns:
├── Strong Consistency: Financial transactions (ACID)
├── Eventual Consistency: Analytics and reporting
├── Saga Pattern: Distributed transaction coordination
├── Two-Phase Commit: Critical financial operations
└── Compensating Actions: Rollback mechanisms
```

### **Security Architecture**
```yaml
Authentication & Authorization:
├── JWT with short expiry (15 minutes)
├── Refresh token rotation
├── Role-based access control (RBAC)
├── API gateway with rate limiting
└── Service-to-service authentication (mTLS)

Data Protection:
├── Encryption at rest (AES-256)
├── Encryption in transit (TLS 1.3)
├── Field-level encryption for PII
├── Key management (Vault integration)
└── Data masking in logs
```

### **Compliance & Monitoring**
```yaml
Audit Requirements:
├── Immutable audit logs
├── Complete data lineage tracking
├── Regulatory reporting capabilities
├── Data retention policies (7 years)
└── Right to be forgotten implementation

Monitoring & Alerting:
├── Business transaction monitoring
├── Fraud detection patterns
├── Performance monitoring (SLA compliance)
├── Security event monitoring
└── Compliance dashboard and reporting
```

---

## 🎯 MVP Implementation Priority

### **Phase 1: Core Foundation (Month 1-2)**
1. **User Service**: Registration, login, basic profile
2. **Transaction Service**: CRUD operations, basic validation
3. **Basic Analytics**: Current balance, simple summaries
4. **Event Infrastructure**: Basic event publishing/consuming

### **Phase 2: FSI Compliance (Month 3-4)**  
1. **Security Hardening**: MFA, encryption, audit logging
2. **Data Integrity**: Event sourcing, immutable logs
3. **Regulatory Features**: Data retention, export capabilities
4. **Monitoring**: Compliance dashboards, alerting

### **Phase 3: Advanced Features (Month 5-6)**
1. **Advanced Analytics**: Trends, projections, insights
2. **Notification Service**: Multi-channel communication
3. **Integration Hub**: External bank connections (optional)
4. **Performance Optimization**: Caching, async processing

This specification balances MVP simplicity with FSI compliance requirements, providing a realistic foundation for a portfolio-grade financial services application while demonstrating enterprise-level architecture patterns.