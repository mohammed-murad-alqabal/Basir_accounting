# Feature Specifications: Baseer Intelligent Financial System

**Document ID:** BASEER-P3-007  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Product Planning

---

## 1. Invoice Creation Feature

### Overview

Quick and professional invoice creation with ZATCA compliance.

### User Flow

```
Dashboard → FAB → New Invoice → Select Customer → Add Items → Review → Send/Save
```

### Screen Specifications

#### Invoice Form Screen

| Element        | Type       | Validation             | Notes                |
| -------------- | ---------- | ---------------------- | -------------------- |
| Customer       | Selector   | Required               | Can create inline    |
| Invoice Number | Auto       | Generated              | INV-YYYY-NNNN format |
| Issue Date     | DatePicker | Required, ≤ Today      | Default: Today       |
| Due Date       | DatePicker | Required, ≥ Issue Date | Default: +30 days    |
| Items          | List       | Min 1 item             | Add/remove buttons   |
| Notes          | TextArea   | Optional               | Max 500 chars        |
| Tax Rate       | Selector   | 0%, 5%, 15%            | Default: 15%         |

#### Line Item Fields

| Field       | Type       | Validation        |
| ----------- | ---------- | ----------------- |
| Description | Text       | Required, max 200 |
| Quantity    | Number     | Required, > 0     |
| Unit Price  | Currency   | Required, ≥ 0     |
| Amount      | Calculated | qty × price       |

### Business Rules

| Rule              | Logic                       |
| ----------------- | --------------------------- |
| Subtotal          | Sum of all item amounts     |
| Tax Amount        | Subtotal × tax rate         |
| Total             | Subtotal + Tax Amount       |
| Number Generation | Sequential per organization |
| ZATCA QR          | Generated on save (Saudi)   |

### API Endpoints

| Method | Endpoint             | Purpose        |
| ------ | -------------------- | -------------- |
| POST   | `/invoices`          | Create invoice |
| GET    | `/invoices/:id`      | Get invoice    |
| PUT    | `/invoices/:id`      | Update draft   |
| POST   | `/invoices/:id/send` | Mark as sent   |

---

## 2. Receipt Scanning Feature

### Overview

OCR-powered expense creation from receipt photos.

### User Flow

```
Expenses → Add → Scan Receipt → Camera Capture → AI Processing → Confirm → Save
```

### Screen Specifications

#### Camera Screen

| Element        | Notes                     |
| -------------- | ------------------------- |
| Camera Preview | Full screen               |
| Guide Overlay  | Receipt positioning guide |
| Capture Button | Center bottom             |
| Flash Toggle   | Top right                 |
| Gallery Option | Bottom left               |

#### Confirmation Screen

| Field         | Source        | Editable  |
| ------------- | ------------- | --------- |
| Merchant      | OCR           | Yes       |
| Amount        | OCR           | Yes       |
| Date          | OCR           | Yes       |
| Category      | AI Suggestion | Yes       |
| Receipt Image | Camera        | View only |

### OCR Processing

```dart
class ReceiptProcessor {
  Future<ReceiptData> process(Uint8List imageBytes) async {
    // 1. Image enhancement
    final enhanced = await _enhanceImage(imageBytes);

    // 2. OCR extraction
    final text = await _extractText(enhanced);

    // 3. Entity extraction
    final entities = _extractEntities(text);

    // 4. Category prediction
    final category = await _predictCategory(entities.merchant);

    return ReceiptData(
      merchant: entities.merchant,
      amount: entities.amount,
      date: entities.date,
      suggestedCategory: category,
      rawText: text,
    );
  }
}
```

### Performance Targets

| Metric                | Target      |
| --------------------- | ----------- |
| OCR Accuracy (Arabic) | > 90%       |
| Processing Time       | < 3 seconds |
| Category Accuracy     | > 85%       |

---

## 3. Dashboard Feature

### Overview

Real-time financial overview with key metrics.

### Widget Layout

```
┌─────────────────────────────────────┐
│  Balance Summary (Income - Expenses) │
├─────────────────────────────────────┤
│  Quick Actions (4 icons)             │
├─────────────────────────────────────┤
│  Recent Invoices (3 items)           │
├─────────────────────────────────────┤
│  Overdue Alerts (if any)             │
├─────────────────────────────────────┤
│  Recent Transactions (5 items)       │
└─────────────────────────────────────┘
```

### Widgets

#### Balance Summary

| Metric   | Calculation                   |
| -------- | ----------------------------- |
| Income   | Sum of paid invoices (period) |
| Expenses | Sum of expenses (period)      |
| Net      | Income - Expenses             |
| Period   | Default: Current month        |

#### Quick Actions

| Action       | Icon         | Navigation   |
| ------------ | ------------ | ------------ |
| New Invoice  | receipt_long | Invoice form |
| Add Expense  | add_card     | Expense form |
| Scan Receipt | camera       | Camera       |
| View Reports | bar_chart    | Reports      |

#### Overdue Alerts

| Condition   | Display             |
| ----------- | ------------------- |
| Any overdue | Red card with count |
| None        | Hidden              |

### Refresh Behavior

| Trigger      | Action                 |
| ------------ | ---------------------- |
| Screen focus | Refresh if > 60s stale |
| Pull down    | Force refresh          |
| Timer        | Refresh every 5 min    |

---

## 4. Multi-Currency Support

### Supported Currencies

| Code | Name            | Symbol | Countries    |
| ---- | --------------- | ------ | ------------ |
| SAR  | Saudi Riyal     | ر.س    | Saudi Arabia |
| AED  | UAE Dirham      | د.إ    | UAE          |
| EGP  | Egyptian Pound  | ج.م    | Egypt        |
| KWD  | Kuwaiti Dinar   | د.ك    | Kuwait       |
| QAR  | Qatari Riyal    | ر.ق    | Qatar        |
| BHD  | Bahraini Dinar  | د.ب    | Bahrain      |
| OMR  | Omani Rial      | ر.ع    | Oman         |
| JOD  | Jordanian Dinar | د.أ    | Jordan       |
| USD  | US Dollar       | $      | All          |

### Currency Display

```dart
String formatCurrency(double amount, String currencyCode) {
  final format = NumberFormat.currency(
    locale: _getLocale(currencyCode),
    symbol: _getSymbol(currencyCode),
    decimalDigits: _getDecimals(currencyCode),
  );
  return format.format(amount);
}
```

### Exchange Rates

| Source                  | Update Frequency |
| ----------------------- | ---------------- |
| Open Exchange Rates API | Daily            |
| Cache                   | 24 hours         |
| Fallback                | Last known rate  |

---

## 5. Notification System

### Notification Types

| Type                 | Trigger          | Channel      |
| -------------------- | ---------------- | ------------ |
| Invoice Overdue      | Due date passed  | Push + Email |
| Payment Received     | Manual marking   | Push         |
| Budget Alert         | 80%/100% reached | Push         |
| Subscription Renewal | 3 days before    | Push         |
| Weekly Summary       | Every Sunday     | Email        |

### Push Notification Structure

```json
{
  "title": "فاتورة متأخرة",
  "body": "الفاتورة INV-2025-0042 لشركة ABC متأخرة بـ 5 أيام",
  "data": {
    "type": "invoice_overdue",
    "invoice_id": "uuid",
    "action": "view_invoice"
  }
}
```

### Notification Preferences

| Setting             | Options    | Default |
| ------------------- | ---------- | ------- |
| Push Notifications  | On/Off     | On      |
| Email Notifications | On/Off     | On      |
| Overdue Reminders   | 1/3/7 days | 3 days  |
| Weekly Summary      | On/Off     | On      |

---

## 6. Settings & Preferences

### Settings Categories

| Category      | Options                     |
| ------------- | --------------------------- |
| Account       | Profile, password, logout   |
| Organization  | Business info, tax settings |
| Appearance    | Theme, language             |
| Notifications | All notification prefs      |
| Data          | Export, backup              |
| About         | Version, licenses, support  |

### Theme Options

| Setting       | Options                         |
| ------------- | ------------------------------- |
| Theme         | Light, Dark, System             |
| Language      | العربية, English                |
| Number Format | Western (1,2,3), Arabic (١،٢،٣) |
| Date Format   | Gregorian, Hijri, Both          |

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
