---
id: "ears-requirements-template"
description: "قالب متطلبات بنهج EARS (EARS Requirements Template)"
version: "1.0"
metrics:
  clarity: "High"
  testability: "High"
---

# EARS Requirements Template

**Easy Approach to Requirements Syntax**

## 1. Ubiquitous Requirements (Always)

**Syntax:** The [System] shall [Response].

- The System shall authenticate users before access.
- The System shall log all transaction attempts.

## 2. Event-Driven Requirements (When)

**Syntax:** When [Trigger], the [System] shall [Response].

- When a new customer is registered, the System shall send a welcome email.
- When an invoice is paid, the System shall update the balance.

## 3. Unwanted Behaviour Requirements (If)

**Syntax:** If [Precondition/Trigger], then the [System] shall [Response].

- If the payment fails, then the System shall notify the user.
- If the network is unavailable, then the System shall queue requests.

## 4. State-Driven Requirements (While)

**Syntax:** While [State], the [System] shall [Response].

- While in maintenance mode, the System shall reject non-admin logins.
- While the device is offline, the System shall allow read-only access.

## 5. Optional Feature Requirements (Where)

**Syntax:** Where [Feature] is included, the [System] shall [Response].

- Where geolocation is enabled, the System shall tag invoices with location.

---

## Validation Checklist

- [ ] No ambiguity (avoid "should", "might", "etc.")
- [ ] Testable (clear inputs and outputs)
- [ ] Traceable (linked to ID)
