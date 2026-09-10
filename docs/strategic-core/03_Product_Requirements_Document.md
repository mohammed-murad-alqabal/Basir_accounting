# Product Requirements Document (PRD) - Initial Version (MVP)

## 1. Introduction

This document defines the functional and non-functional requirements for the **Basir** MVP. The focus is on core features: localized user authentication, customer management, and a streamlined invoicing workflow, providing a high-quality Arabic-first user experience.

## 2. Functional Requirements

### 2.1. Authentication and Initial Setup

| ID        | User Story                                                                                      | Acceptance Criteria                                                                                                                                                                                                   |
| :-------- | :---------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **FR-01** | **As a new user,** I want to set up a username and password to protect my local financial data. | - Initial setup screen must appear when the app is launched for the first time.<br>- Credentials must be stored securely and encrypted locally.<br>- User must be redirected to the Dashboard after successful setup. |
| **FR-02** | **As a returning user,** I want to log in using my credentials to access my data.               | - Login screen must appear on subsequent app launches.<br>- Credentials must be verified against the local secure storage.<br>- User must be redirected to the Dashboard upon successful login.                       |

### 2.2. Customer Management

| ID        | User Story                                                             | Acceptance Criteria                                                                                                                    |
| :-------- | :--------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------- |
| **FR-03** | **As a user,** I want to add a new customer with their basic profiles. | - Required fields: Full Name, Phone Number, Email. Optional: Address.<br>- Customer data must be persisted in the local Isar database. |
| **FR-04** | **As a user,** I want to view a list of all my customers.              | - List must be searchable and filterable by name.<br>- List should display at least the name and phone number for each customer.       |
| **FR-05** | **As a user,** I want to edit or delete existing customer information. | - Data must be permanently updated or removed from the local database.                                                                 |

### 2.3. Invoice Management

| ID        | User Story                                                                      | Acceptance Criteria                                                                                                                                                              |
| :-------- | :------------------------------------------------------------------------------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **FR-06** | **As a user,** I want to easily create a new invoice.                           | - Creation interface must include fields for: Customer Selection, Issue Date, Due Date, and Line Items.<br>- User must be able to add/remove line items (Name, Quantity, Price). |
| **FR-07** | **As a user,** I want invoice totals and taxes to be calculated automatically.  | - Subtotal, Tax Total, and Grand Total must be calculated in real-time during entry.<br>- Tax rate must be configurable in settings (single rate for MVP).                       |
| **FR-08** | **As a user,** I want to save an invoice as a draft or issue it as final.       | - All invoice details must be saved to the local database with a status of "Draft" or "Issued".                                                                                  |
| **FR-09** | **As a user,** I want to view a list of all my invoices.                        | - List must be filterable by status (Draft, Due, Paid) and by Customer.<br>- List should display: Invoice Number, Customer Name, Due Date, and Grand Total.                      |
| **FR-10** | **As a user,** I want to view specific invoice details and update their status. | - Details screen must show all line items and final calculations.<br>- User must be able to mark an invoice as "Paid" or "Cancelled".                                            |

### 2.4. Dashboard

| ID        | User Story                                                                   | Acceptance Criteria                                                                                                       |
| :-------- | :--------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------ |
| **FR-11** | **As a user,** I want to see a quick financial summary upon opening the app. | - Dashboard must display: Total Due Invoices amount, Total Paid Invoices amount, and total count of registered customers. |

## 3. Non-Functional Requirements

| Type            | Requirement                                                                                                                                                                                             |
| :-------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Performance** | All screens must load in less than 1.5 seconds on modern devices. Database save/update operations must complete within 500 milliseconds.                                                                |
| **Security**    | Sensitive credentials must be stored in an encrypted format. All financial data must remain strictly local and never be transmitted over the internet without explicit user consent (deferred feature). |
| **Usability**   | The application must fully support the Arabic language (Right-to-Left). The UI should be intuitive and follow standard mobile design guidelines (Material Design / Cupertino).                          |
| **Scalability** | Code must be structured using Clean Architecture to facilitate the future addition of API and Cloud Backend layers without rewriting core business logic.                                               |
