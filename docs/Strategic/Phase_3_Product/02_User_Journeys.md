# User Journeys & Flows: Basir Intelligent Financial System

**Document ID:** basir-P3-003  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Product Planning

---

## Journey 1: First-Time User Onboarding

### Journey Map

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│Download │──▶│ Welcome │──▶│ Choose  │──▶│ Quick   │──▶│ Ready!  │
│   App   │   │ Screen  │   │  Mode   │   │  Setup  │   │         │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
                                │                           │
                         ┌──────┴──────┐                   │
                         ▼             ▼                   ▼
                    Business      Personal            Dashboard
```

### Steps

| Step | Screen         | User Action                  | System Response           |
| ---- | -------------- | ---------------------------- | ------------------------- |
| 1    | App Store      | Download app                 | Install completes         |
| 2    | Splash         | Open app                     | Show welcome              |
| 3    | Welcome        | Tap "Get Started"            | Show mode selection       |
| 4    | Mode Selection | Choose Personal/Business     | Show relevant setup       |
| 5    | Account Setup  | Enter email, create password | Validate, store securely  |
| 6    | Profile Setup  | Enter name, business details | Save profile              |
| 7    | Preferences    | Select currency, language    | Apply settings            |
| 8    | Tutorial       | View quick tips              | Mark as seen              |
| 9    | Dashboard      | View empty state             | Show first-action prompts |

### Metrics

- **Completion Rate Target:** > 80%
- **Time to Complete:** < 3 minutes
- **Drop-off Points:** Monitor step 5-6

---

## Journey 2: Create Invoice (Khalid - Freelancer)

### Journey Map

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│Dashboard│──▶│  New    │──▶│  Add    │──▶│ Review  │──▶│  Send   │
│   FAB   │   │ Invoice │   │  Items  │   │   & OK  │   │  Done!  │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
     │              │              │              │              │
     │         Choose         Add line       Preview        Email/
    Tap +      customer       items & tax     & edit        Share
```

### Steps

| Step | Screen       | User Action            | System Response         |
| ---- | ------------ | ---------------------- | ----------------------- |
| 1    | Dashboard    | Tap FAB (+)            | Show action menu        |
| 2    | Action Menu  | Select "New Invoice"   | Open invoice form       |
| 3    | Customer     | Select/create customer | Auto-fill customer info |
| 4    | Details      | Set date, due date     | Calculate due           |
| 5    | Items        | Add line items         | Calculate subtotal      |
| 6    | Items        | Add more items         | Update totals live      |
| 7    | Tax          | Confirm tax rate       | Calculate tax + total   |
| 8    | Preview      | Review invoice         | Show ZATCA QR           |
| 9    | Actions      | Tap "Send"             | Show share options      |
| 10   | Share        | Choose email/WhatsApp  | Generate PDF, send      |
| 11   | Confirmation | See success            | Update invoice status   |

### Metrics

- **Time to Create:** < 30 seconds
- **Completion Rate:** > 95%
- **Error Rate:** < 2%

---

## Journey 3: Track Expenses (Noura - Business Owner)

### Journey Map

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│Scan     │──▶│ OCR     │──▶│ Confirm │──▶│ Saved!  │
│Receipt  │   │ Results │   │ Details │   │         │
└─────────┘   └─────────┘   └─────────┘   └─────────┘
     │              │              │              │
   Camera       AI extract    Edit if       Categorized
   capture        data        needed        & stored
```

### Steps

| Step | Screen      | User Action             | System Response             |
| ---- | ----------- | ----------------------- | --------------------------- |
| 1    | Dashboard   | Tap "Add Expense"       | Show options                |
| 2    | Options     | Choose "Scan Receipt"   | Open camera                 |
| 3    | Camera      | Capture receipt         | Process OCR                 |
| 4    | OCR Results | Review extracted data   | Show merchant, amount, date |
| 5    | Confirm     | Edit if needed, confirm | AI suggest category         |
| 6    | Category    | Confirm/change category | Save expense                |
| 7    | Success     | See confirmation        | Return to list              |

### Metrics

- **OCR Accuracy:** > 90% for Arabic
- **Time to Add:** < 15 seconds with OCR
- **Category Accuracy:** > 85%

---

## Journey 4: Budget Creation (Ahmed - Individual)

### Journey Map

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│Personal │──▶│ Create  │──▶│  Set    │──▶│ Active  │
│  Home   │   │ Budget  │   │ Limits  │   │ Budget  │
└─────────┘   └─────────┘   └─────────┘   └─────────┘
     │              │              │              │
   Tap           Name &         Amount      Track
  Budget        Period        per category  spending
```

### Steps

| Step | Screen     | User Action              | System Response      |
| ---- | ---------- | ------------------------ | -------------------- |
| 1    | Home       | Tap "Create Budget"      | Open budget wizard   |
| 2    | Name       | Enter budget name        | Validate             |
| 3    | Period     | Select monthly/custom    | Set date range       |
| 4    | Income     | Enter expected income    | Store                |
| 5    | Categories | See suggested categories | AI-based suggestions |
| 6    | Limits     | Set limit per category   | Calculate remaining  |
| 7    | Review     | See budget summary       | Confirm totals       |
| 8    | Activate   | Tap "Start Budget"       | Create and activate  |
| 9    | Dashboard  | See budget widget        | Real-time tracking   |

---

## Journey 5: Payment Follow-Up (Business)

### Journey Map

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│Overdue  │──▶│ Invoice │──▶│  Send   │──▶│Reminder │
│  Alert  │   │ Details │   │Reminder │   │  Sent   │
└─────────┘   └─────────┘   └─────────┘   └─────────┘
     │              │              │              │
 Notification   View         Customize      Auto-update
               details        message         status
```

### Steps

| Step | Screen       | User Action              | System Response       |
| ---- | ------------ | ------------------------ | --------------------- |
| 1    | Push         | Receive overdue alert    | Tap to open           |
| 2    | Invoice      | View overdue invoice     | Show details          |
| 3    | Actions      | Tap "Send Reminder"      | Show reminder options |
| 4    | Customize    | Edit message if needed   | Preview               |
| 5    | Send         | Confirm send             | Email/WhatsApp        |
| 6    | Confirmation | See sent confirmation    | Log reminder          |
| 7    | Timeline     | View in invoice timeline | Track follow-ups      |

---

## User Flow Diagram: Main Navigation

```
                          ┌─────────────────┐
                          │   App Launch    │
                          └────────┬────────┘
                                   │
                    ┌──────────────┴──────────────┐
                    │                             │
             ┌──────▼──────┐              ┌──────▼──────┐
             │ Logged Out  │              │ Logged In   │
             └──────┬──────┘              └──────┬──────┘
                    │                             │
            ┌───────┴───────┐                     │
            ▼               ▼                     ▼
       ┌─────────┐    ┌─────────┐         ┌─────────────┐
       │  Login  │    │ Sign Up │         │  Dashboard  │
       └────┬────┘    └────┬────┘         └──────┬──────┘
            │              │                     │
            └──────┬───────┘          ┌──────────┼──────────┐
                   │                  │          │          │
                   ▼                  ▼          ▼          ▼
            ┌─────────────┐     ┌─────────┐ ┌────────┐ ┌─────────┐
            │  Dashboard  │     │Invoices │ │Expenses│ │Customers│
            └─────────────┘     └─────────┘ └────────┘ └─────────┘
```

---

**Document Control:**

- Prepared by: Basir Development Agent Team
- Date: December 27, 2025
