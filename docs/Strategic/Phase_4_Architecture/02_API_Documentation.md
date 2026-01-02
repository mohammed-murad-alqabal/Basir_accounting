# API Design & Documentation: Basir Intelligent Financial System

**Document ID:** basir-P4-003  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Technical Architecture

---

## 1. API Overview

### Base URL

```
Production:  https://api.basir.app/v1
Staging:     https://api-staging.basir.app/v1
```

### Standards

- RESTful design principles
- JSON request/response bodies
- ISO 8601 date formats
- UUID identifiers
- HTTP status codes for errors

### Authentication

- Bearer token (JWT) in Authorization header
- `Authorization: Bearer <token>`

---

## 2. Common Patterns

### Request Headers

| Header            | Required | Description                   |
| ----------------- | -------- | ----------------------------- |
| `Authorization`   | Yes      | Bearer JWT token              |
| `Content-Type`    | Yes      | application/json              |
| `Accept-Language` | No       | ar, en (default: ar)          |
| `X-Request-ID`    | No       | Client request ID for tracing |

### Response Format

**Success:**

```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 150
  }
}
```

**Error:**

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [{ "field": "email", "message": "Invalid email format" }]
  }
}
```

### Pagination

```
GET /invoices?page=2&per_page=20
```

---

## 3. API Endpoints

### Authentication

#### POST /auth/register

Create new account

**Request:**

```json
{
  "email": "user@example.com",
  "password": "SecurePass123",
  "name": "أحمد محمد",
  "organization_name": "شركة التقنية",
  "country": "SA"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "أحمد محمد"
    },
    "organization": {
      "id": "uuid",
      "name": "شركة التقنية"
    },
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "expires_at": "2025-12-27T01:00:00Z"
  }
}
```

---

#### POST /auth/login

Authenticate user

**Request:**

```json
{
  "email": "user@example.com",
  "password": "SecurePass123"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "expires_at": "2025-12-27T01:00:00Z",
    "user": { ... }
  }
}
```

---

#### POST /auth/refresh

Refresh access token

**Request:**

```json
{
  "refresh_token": "eyJ..."
}
```

---

### Invoices

#### GET /invoices

List invoices (paginated)

**Query Parameters:**
| Param | Type | Description |
|-------|------|-------------|
| `page` | int | Page number (default: 1) |
| `per_page` | int | Items per page (max: 100) |
| `status` | string | Filter: draft, sent, paid, overdue |
| `customer_id` | uuid | Filter by customer |
| `from_date` | date | Issue date from |
| `to_date` | date | Issue date to |

**Response:** `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "number": "INV-2025-0001",
      "status": "sent",
      "customer": {
        "id": "uuid",
        "name": "شركة العميل"
      },
      "issue_date": "2025-12-20",
      "due_date": "2025-01-19",
      "total": 1150.0,
      "currency": "SAR"
    }
  ],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 45
  }
}
```

---

#### POST /invoices

Create new invoice

**Request:**

```json
{
  "customer_id": "uuid",
  "issue_date": "2025-12-27",
  "due_date": "2026-01-26",
  "items": [
    {
      "description": "خدمات تصميم",
      "quantity": 10,
      "unit_price": 100.0,
      "tax_rate": 15
    }
  ],
  "notes": "شكراً لتعاملكم معنا",
  "status": "draft"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "number": "INV-2025-0001",
    "status": "draft",
    "subtotal": 1000.00,
    "tax_total": 150.00,
    "total": 1150.00,
    "zatca_qr": "base64...",
    ...
  }
}
```

---

#### GET /invoices/:id

Get invoice details

---

#### PUT /invoices/:id

Update invoice (draft only)

---

#### POST /invoices/:id/send

Mark invoice as sent

---

#### POST /invoices/:id/pay

Record payment

**Request:**

```json
{
  "amount": 1150.0,
  "method": "bank_transfer",
  "paid_at": "2025-12-27",
  "reference": "TRN123456"
}
```

---

#### GET /invoices/:id/pdf

Download invoice as PDF

**Response:** `200 OK`

- Content-Type: application/pdf
- Binary PDF file

---

### Customers

#### GET /customers

List customers

#### POST /customers

Create customer

#### GET /customers/:id

Get customer details

#### PUT /customers/:id

Update customer

#### DELETE /customers/:id

Soft delete customer

---

### Expenses

#### GET /expenses

List expenses

#### POST /expenses

Create expense

#### POST /expenses/scan

Create expense from receipt scan

**Request:** multipart/form-data

- `receipt`: image file

**Response:**

```json
{
  "success": true,
  "data": {
    "merchant": "مطعم الريف",
    "amount": 85.0,
    "date": "2025-12-27",
    "category_suggestion": {
      "id": "uuid",
      "name": "مطاعم",
      "confidence": 0.92
    },
    "raw_text": "..."
  }
}
```

---

### Reports

#### GET /reports/summary

Financial summary

**Query Parameters:**

- `from_date`: start date
- `to_date`: end date

**Response:**

```json
{
  "success": true,
  "data": {
    "total_income": 50000.0,
    "total_expenses": 15000.0,
    "net": 35000.0,
    "invoices": {
      "count": 25,
      "paid": 20,
      "pending": 5
    }
  }
}
```

---

## 4. Error Codes

| Code               | HTTP Status | Description              |
| ------------------ | ----------- | ------------------------ |
| `UNAUTHORIZED`     | 401         | Invalid/missing token    |
| `FORBIDDEN`        | 403         | Insufficient permissions |
| `NOT_FOUND`        | 404         | Resource not found       |
| `VALIDATION_ERROR` | 422         | Invalid input            |
| `RATE_LIMITED`     | 429         | Too many requests        |
| `SERVER_ERROR`     | 500         | Internal error           |

---

## 5. Rate Limiting

| Endpoint             | Limit      |
| -------------------- | ---------- |
| `/auth/*`            | 10/minute  |
| `GET /*`             | 100/minute |
| `POST/PUT/DELETE /*` | 50/minute  |

---

**Document Control:**

- Prepared by: Basir Development Agent Team
- Date: December 27, 2025
