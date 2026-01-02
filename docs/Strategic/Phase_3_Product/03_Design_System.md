# Design System: Basir Intelligent Financial System

**Document ID:** basir-P3-004  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Product Planning

---

## 1. Design Principles

### Core Principles

| Principle        | Description                                     |
| ---------------- | ----------------------------------------------- |
| **Arabic-First** | Designed for RTL, not adapted                   |
| **Clarity**      | Financial data must be instantly understandable |
| **Trust**        | Professional aesthetics inspire confidence      |
| **Speed**        | Minimize clicks, maximize efficiency            |
| **Delight**      | Micro-interactions that feel premium            |

---

## 2. Color System

### Primary Colors

| Name              | Hex       | Usage                   |
| ----------------- | --------- | ----------------------- |
| **Primary Blue**  | `#0066CC` | CTAs, highlights, links |
| **Primary Dark**  | `#003366` | Headers, emphasis       |
| **Primary Light** | `#E6F0FA` | Backgrounds, hover      |

### Semantic Colors

| Name        | Hex       | Usage                  |
| ----------- | --------- | ---------------------- |
| **Success** | `#00AA55` | Positive amounts, paid |
| **Warning** | `#FF9900` | Alerts, pending        |
| **Error**   | `#DD3333` | Errors, overdue        |
| **Info**    | `#0099CC` | Information, tips      |

### Neutral Colors

| Name           | Hex       | Usage             |
| -------------- | --------- | ----------------- |
| **Black**      | `#1A1A1A` | Primary text      |
| **Dark Gray**  | `#4A4A4A` | Secondary text    |
| **Gray**       | `#757575` | Tertiary text     |
| **Light Gray** | `#E5E5E5` | Borders, dividers |
| **Off White**  | `#F5F5F5` | Backgrounds       |
| **White**      | `#FFFFFF` | Cards, surfaces   |

### Dark Mode Colors

| Light     | Dark      |
| --------- | --------- |
| `#FFFFFF` | `#1A1A1A` |
| `#F5F5F5` | `#2D2D2D` |
| `#1A1A1A` | `#FFFFFF` |

---

## 3. Typography

### Font Families

| Use           | Arabic               | English        |
| ------------- | -------------------- | -------------- |
| **Primary**   | Cairo                | Inter          |
| **Monospace** | IBM Plex Mono Arabic | JetBrains Mono |

### Type Scale

| Name           | Size | Weight         | Line Height | Use             |
| -------------- | ---- | -------------- | ----------- | --------------- |
| **Display**    | 32px | Bold (700)     | 1.2         | Page titles     |
| **H1**         | 24px | Bold (700)     | 1.3         | Section headers |
| **H2**         | 20px | SemiBold (600) | 1.3         | Subsections     |
| **H3**         | 18px | SemiBold (600) | 1.4         | Card titles     |
| **Body**       | 16px | Regular (400)  | 1.5         | Content         |
| **Body Small** | 14px | Regular (400)  | 1.5         | Secondary       |
| **Caption**    | 12px | Regular (400)  | 1.4         | Labels, hints   |
| **Button**     | 16px | SemiBold (600) | 1.2         | CTAs            |

---

## 4. Spacing System

### Base Unit: 4px

| Token       | Value | Use              |
| ----------- | ----- | ---------------- |
| `space-xs`  | 4px   | Tight spacing    |
| `space-sm`  | 8px   | Related elements |
| `space-md`  | 16px  | Standard spacing |
| `space-lg`  | 24px  | Section gaps     |
| `space-xl`  | 32px  | Major sections   |
| `space-2xl` | 48px  | Page margins     |

---

## 5. Component Library

### Buttons

| Type          | Use                 | Style                  |
| ------------- | ------------------- | ---------------------- |
| **Primary**   | Main actions        | Filled, Primary Blue   |
| **Secondary** | Secondary actions   | Outlined, Primary Blue |
| **Ghost**     | Tertiary actions    | Text only              |
| **Danger**    | Destructive actions | Filled, Error Red      |

### Button States

| State    | Style             |
| -------- | ----------------- |
| Default  | Full opacity      |
| Hover    | 10% darker        |
| Pressed  | 20% darker        |
| Disabled | 50% opacity       |
| Loading  | Spinner, disabled |

### Input Fields

| Type               | Use                |
| ------------------ | ------------------ |
| **Text Input**     | Single-line text   |
| **Text Area**      | Multi-line text    |
| **Select**         | Dropdown selection |
| **Date Picker**    | Hijri + Gregorian  |
| **Currency Input** | Formatted numbers  |
| **Search**         | Search with icon   |

### Cards

| Type                 | Use               |
| -------------------- | ----------------- |
| **Standard Card**    | Content container |
| **Interactive Card** | Clickable items   |
| **Summary Card**     | Metrics display   |
| **Invoice Card**     | Invoice list item |

### Navigation

| Component      | Use                              |
| -------------- | -------------------------------- |
| **Bottom Nav** | Primary mobile nav (5 items max) |
| **Tab Bar**    | Section switching                |
| **Drawer**     | Secondary navigation             |
| **App Bar**    | Screen header with actions       |

---

## 6. Icons

### Icon Library

Using **Phosphor Icons** - consistent, RTL-friendly

### Icon Sizes

| Size   | Value | Use                |
| ------ | ----- | ------------------ |
| **XS** | 16px  | Inline text        |
| **SM** | 20px  | Buttons, inputs    |
| **MD** | 24px  | Navigation, lists  |
| **LG** | 32px  | Feature highlights |
| **XL** | 48px  | Empty states       |

---

## 7. Motion & Animation

### Duration Scale

| Token             | Value | Use                  |
| ----------------- | ----- | -------------------- |
| `duration-fast`   | 100ms | Micro-interactions   |
| `duration-normal` | 200ms | Standard transitions |
| `duration-slow`   | 300ms | Page transitions     |

### Easing

| Token         | Value                        | Use   |
| ------------- | ---------------------------- | ----- |
| `ease-in`     | cubic-bezier(0.4, 0, 1, 1)   | Exit  |
| `ease-out`    | cubic-bezier(0, 0, 0.2, 1)   | Enter |
| `ease-in-out` | cubic-bezier(0.4, 0, 0.2, 1) | Move  |

---

## 8. Responsive Breakpoints

| Name        | Width      | Columns |
| ----------- | ---------- | ------- |
| **Mobile**  | 320-767px  | 4       |
| **Tablet**  | 768-1023px | 8       |
| **Desktop** | 1024px+    | 12      |

---

## 9. RTL Considerations

### Layout Mirroring

- All layouts flow RTL by default
- Icons mirror when directional
- Text alignment: right for Arabic

### Numbers

- Western Arabic numerals (1, 2, 3) by default
- Eastern Arabic (١، ٢، ٣) optional
- Currency always follows locale

### Dates

- Gregorian default, Hijri available
- Format: DD/MM/YYYY for Arabic locale

---

## 10. Accessibility

### Color Contrast

- Text on background: AAA (7:1 min)
- Large text: AA (4.5:1 min)
- UI components: 3:1 min

### Touch Targets

- Minimum: 44x44px
- Recommended: 48x48px

### Screen Readers

- All elements labeled
- Arabic VoiceOver tested
- Logical reading order

---

**Document Control:**

- Prepared by: Basir Development Agent Team
- Date: December 27, 2025
