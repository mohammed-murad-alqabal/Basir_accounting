# Basir Product Charter - Initial Version (MVP)

## 1. Vision

To establish **Basir** as the leading intelligent financial operating system in the Arab world, seamlessly integrating personal finance management with business accounting. The vision is to empower individuals and small-to-medium enterprises (SMEs) to make informed and effective financial decisions through actionable insights.

## 2. Mission

To provide a professional mobile application (MVP) characterized by simplicity, speed, and reliability. The mission focuses on enabling users to **manage customers and create/track invoices** locally on the device, while establishing a robust engineering core scalable for future regional requirements (such as ZATCA compliance) and integrated financial services.

## 3. Strategic Objectives for MVP

| Objective                            | Description                                                                                                           | Key Performance Indicator (KPI)                                                        |
| :----------------------------------- | :-------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------- |
| **1. Core Value Validation**         | Prove that users find tangible value in using the app for basic invoice creation and tracking.                        | At least one invoice created per active monthly user.                                  |
| **2. Robust Engineering Foundation** | Develop the application using industry best practices (Clean Architecture) to ensure maintainability and scalability. | High Code Quality Score and scalability without requiring radical restructuring.       |
| **3. Exceptional User Experience**   | Provide a seamless, attractive, and intuitive Arabic UI/UX focusing on high performance.                              | High Customer Satisfaction (CSAT) score; invoice creation screen load time < 1 second. |
| **4. Local Data Security**           | Ensure the protection of financial data stored locally on the user's device.                                          | Implementation of local authentication (Username/Password) and local data encryption.  |

## 4. MVP Scope

The initial product is a mobile application (Android/iOS) built using Flutter, operating independently (Standalone) without a backend server requirement in this phase.

### In-Scope Features

1.  **Local Authentication**: Initial setup screen (Username and Password) to protect the application.
2.  **Customer Management**: Add, update, and delete basic customer data (Name, Phone Number, Email).
3.  **Invoice Creation**: An intuitive interface for generating new invoices including:
    - Invoice date and due date.
    - Customer selection from a list.
    - Line item management (Name, Quantity, Price).
    - Automatic calculation of totals and taxes (single adjustable tax rate).
    - Save invoice as draft or issue as final.
4.  **Invoice Tracking**: List view of all invoices with filtering capabilities by status (Draft, Due, Paid).
5.  **Dashboard**: A simplified financial summary (Total Invoice Value, Customer Count).
6.  **Local Storage**: Persisting all data (Customers, Invoices, User Settings) locally using the `Isar` database.

### Out-of-Scope (Future Development)

1.  **Backend Infrastructure**: No API integration, no cloud synchronization, and no online login.
2.  **External Integrations**: No bank linking or payment gateway integration.
3.  **Advanced Features**: No detailed accounting reports, no inventory management, and no full ZATCA compliance (the UI will be prepared for it, but encrypted QR generation is deferred).
4.  **Biometric Authentication**: Architecture will support it, but it will not be active in the MVP.

## 5. Core Technologies

- **Platform**: Flutter (Android & iOS).
- **State Management**: Riverpod.
- **Local Storage**: Isar Database.
- **Primary Language**: Arabic (with full support for Right-to-Left (RTL) layout).
