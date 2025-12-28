# User Stories & Acceptance Criteria: Baseer Intelligent Financial System

**Document ID:** BASEER-P3-005  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Product Planning

---

## Epic 1: Authentication & Onboarding

### US-1.1: Email Signup

**As a** new user  
**I want to** create an account with my email  
**So that** I can securely access my financial data

**Acceptance Criteria:**

- [ ] Email format is validated
- [ ] Password requires 8+ chars, 1 number, 1 uppercase
- [ ] Confirmation email is sent
- [ ] Account is created after email verification
- [ ] Error messages are clear and in Arabic/English

**Priority:** P0 | **Points:** 5

---

### US-1.2: Biometric Login

**As a** returning user  
**I want to** login with Face ID or fingerprint  
**So that** I can access my data quickly and securely

**Acceptance Criteria:**

- [ ] Biometric prompt appears after app launch
- [ ] Falls back to password if biometric fails 3 times
- [ ] Works on iOS (Face ID/Touch ID) and Android (fingerprint)
- [ ] Can be disabled in settings

**Priority:** P0 | **Points:** 3

---

### US-1.3: Guest Mode

**As a** potential user  
**I want to** explore the app without signing up  
**So that** I can evaluate it before committing

**Acceptance Criteria:**

- [ ] "Try as Guest" button on welcome screen
- [ ] Core features available with sample data
- [ ] Clear indicators of guest mode limitations
- [ ] Easy path to convert to full account
- [ ] Guest data can be migrated to new account

**Priority:** P0 | **Points:** 5

---

## Epic 2: Invoicing

### US-2.1: Create Invoice

**As a** freelancer  
**I want to** create a professional invoice quickly  
**So that** I can bill my clients efficiently

**Acceptance Criteria:**

- [ ] Invoice creation takes < 30 seconds
- [ ] Customer can be selected or created inline
- [ ] Line items support name, quantity, unit price
- [ ] Tax is calculated automatically
- [ ] Total is calculated in real-time
- [ ] ZATCA QR code is generated for Saudi invoices

**Priority:** P0 | **Points:** 8

---

### US-2.2: ZATCA Compliance

**As a** Saudi business owner  
**I want to** generate ZATCA-compliant invoices  
**So that** I don't face penalties or compliance issues

**Acceptance Criteria:**

- [ ] Invoices include all mandatory ZATCA fields
- [ ] Phase 2 QR code is generated
- [ ] XML output matches ZATCA specifications
- [ ] Tax number is validated
- [ ] Invoice numbering follows ZATCA rules

**Priority:** P0 | **Points:** 13

---

### US-2.3: Track Payments

**As a** business owner  
**I want to** track invoice payment status  
**So that** I know which invoices are paid or overdue

**Acceptance Criteria:**

- [ ] Invoice status shows: Draft, Sent, Paid, Partial, Overdue
- [ ] Can mark invoice as paid with payment date
- [ ] Can record partial payments
- [ ] Overdue invoices are highlighted
- [ ] Payment history is visible on invoice detail

**Priority:** P0 | **Points:** 5

---

### US-2.4: Send Invoice

**As a** business owner  
**I want to** send invoices to customers via email/WhatsApp  
**So that** customers receive professional invoices quickly

**Acceptance Criteria:**

- [ ] PDF is generated with professional design
- [ ] Can share via email (built-in or system)
- [ ] Can share via WhatsApp
- [ ] Customer email is pre-filled if available
- [ ] Invoice status updates to "Sent" after sharing

**Priority:** P0 | **Points:** 5

---

## Epic 3: Expense Management

### US-3.1: Add Expense Manually

**As a** user  
**I want to** add an expense manually  
**So that** I can track my spending

**Acceptance Criteria:**

- [ ] Form includes: amount, date, category, description
- [ ] Category can be selected from list
- [ ] Amount supports decimal input
- [ ] Date defaults to today
- [ ] Expense is saved immediately

**Priority:** P0 | **Points:** 3

---

### US-3.2: Scan Receipt

**As a** business owner  
**I want to** scan a receipt to add an expense  
**So that** I don't have to enter data manually

**Acceptance Criteria:**

- [ ] Camera opens with guidance overlay
- [ ] OCR extracts: merchant, amount, date
- [ ] Works with Arabic text
- [ ] Extracted data can be edited before saving
- [ ] Original image is attached to expense

**Priority:** P0 | **Points:** 8

---

### US-3.3: Auto-Categorization

**As a** user  
**I want to** expenses to be categorized automatically  
**So that** I save time organizing my spending

**Acceptance Criteria:**

- [ ] AI suggests category based on merchant/description
- [ ] Confidence score is shown
- [ ] User can override suggestion
- [ ] System learns from user corrections
- [ ] Accuracy > 85% for common categories

**Priority:** P0 | **Points:** 8

---

## Epic 4: Personal Finance

### US-4.1: Create Budget

**As an** individual  
**I want to** create a monthly budget  
**So that** I can control my spending

**Acceptance Criteria:**

- [ ] Can set budget name and period
- [ ] Can set total budget or by category
- [ ] Categories match expense categories
- [ ] Budget is tracked in real-time
- [ ] Visual progress indicator shows spending vs budget

**Priority:** P1 | **Points:** 5

---

### US-4.2: Budget Alerts

**As an** individual  
**I want to** receive alerts when approaching budget limit  
**So that** I can adjust my spending

**Acceptance Criteria:**

- [ ] Alert at 80% of budget
- [ ] Alert at 100% of budget
- [ ] Push notification sent
- [ ] In-app indicator on category
- [ ] Alert thresholds can be customized

**Priority:** P1 | **Points:** 3

---

## Epic 5: Dashboard & Reports

### US-5.1: Financial Dashboard

**As a** user  
**I want to** see my financial summary at a glance  
**So that** I understand my financial situation

**Acceptance Criteria:**

- [ ] Shows total income (current period)
- [ ] Shows total expenses (current period)
- [ ] Shows outstanding invoices
- [ ] Shows recent transactions
- [ ] Period can be changed (day/week/month)

**Priority:** P0 | **Points:** 5

---

### US-5.2: Tax Report

**As a** business owner  
**I want to** generate a VAT/tax report  
**So that** I can file taxes correctly

**Acceptance Criteria:**

- [ ] Report covers selected date range
- [ ] Shows total VAT collected
- [ ] Shows total VAT paid (on expenses)
- [ ] Shows net VAT payable
- [ ] Can export as PDF/CSV

**Priority:** P0 | **Points:** 5

---

## Story Point Summary

| Epic           | P0 Stories | P1 Stories | Total Points |
| -------------- | ---------- | ---------- | ------------ |
| Authentication | 3          | 0          | 13           |
| Invoicing      | 4          | 0          | 31           |
| Expenses       | 3          | 0          | 19           |
| Personal       | 0          | 2          | 8            |
| Dashboard      | 2          | 0          | 10           |
| **Total**      | **12**     | **2**      | **81**       |

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
