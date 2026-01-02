# API Documentation

**Project:** Basir App  
**Version:** 1.0.0  
**Base URL:** `https://api.example.com/v1`

---

## Authentication

```http
Authorization: Bearer {token}
```

---

## Endpoints

### GET /[resource]

Get all items.

**Response:**

```json
{
  "data": [],
  "total": 0
}
```

### POST /[resource]

Create new item.

**Request:**

```json
{
  "name": "string"
}
```

**Response:**

```json
{
  "id": "string",
  "name": "string"
}
```

---

**Prepared by:** Basir Project Development Agents Team
