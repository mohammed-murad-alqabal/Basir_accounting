# 📜 Basir Technical Specification

**Version:** 1.0 (Phase 26 Hardening)  
**Compliance Level:** IFRS 18, ZATCA Phase 2, ISSB S1/S2  
**Maturity:** 💎 Diamond Purity Certified

---

## 1. Regulatory Compliance Standards

### 1.1 IFRS 18 (Presentation and Disclosure)

Basir classifies all Income Statement and Cash Flow items into the three mandatory categories:

- **Operating Category**: Main business activity revenue and expenses.
- **Investing Category**: Gains/losses from assets and non-operational capital.
- **Financing Category**: Borrowing costs and equity-related transactions.

### 1.2 ZATCA Phase 2 (E-Invoicing)

Full support for the integration phase requirements:

- **Cryptographic Hashing**: SHA-256 generation for every invoice document.
- **ECDSA Signatures**: Digital signatures for UBL 2.1 XML output.
- **UUID v4**: Unique identification for every transaction.
- **PIH (Previous Invoice Hash)**: Sequential chaining for tamper-proof auditing.

---

## 2. Financial Mathematics & Precision

- **Storage Type**: Decimal (String/Custom Rust Object).
- **Precision**: 28 decimal places (via Rust `decimal` crate).
- **Totalization Rules**:
  - `Line Total = (Quantity * UnitPrice) - Discount`.
  - `VAT Amount = Line Total * TaxRate`.
  - `Grand Total = Sum(Line Total) + Sum(VAT Amount)`.

---

## 3. Cognitive Agent Metrics (Consensus Protocol)

Every `JournalEntry` is evaluated against these success criteria:

| Agent                  | Metric                     | Threshold     |
| :--------------------- | :------------------------- | :------------ |
| **Forensic Audit**     | Sequence Gap Detection     | 0 Tolerated   |
| **Tax Engine**         | VAT ID / Category Match    | Mandatory     |
| **Standards Engine**   | Account Nature Consistency | Mandatory     |
| **Sustainability**     | Carbon Keyword Trigger     | Alerting Only |
| **Financial Strategy** | Liquidity Ratio Impact     | Informational |

---

## 4. Hardware & Performance Specs

- **Memory Management**: Background threading for Rust forensic scans.
- **Database**: Isar (NoSQL) with synchronous write transactions for ACID compliance.
- **UI Performance**: Targeting 60/120 FPS via customized "Edge-to-Edge" rendering and font asset optimization.

---

## 5. Security Architecture

- **Encryption**: AES-256 for local database volumes (device-managed).
- **Auth**: Salted SHA-512 hashing for the local master password.
- **Data Integrity**: Cryptographic chaining of journal entries to prevent manual database tampering.

---

💎 **Basir Engineering Standard** | _Institutional Accounting Excellence_
