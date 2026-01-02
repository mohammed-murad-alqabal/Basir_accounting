# Accessibility & Localization Specs: Basir Intelligent Financial System

**Document ID:** basir-P3-006  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Product Planning

---

## 1. Accessibility Standards

### Target Standards

- **WCAG 2.1 Level AA** compliance
- **iOS Accessibility Guidelines**
- **Android Accessibility Guidelines**

---

## 2. Visual Accessibility

### Color & Contrast

| Element                 | Requirement       | Standard        |
| ----------------------- | ----------------- | --------------- |
| Body text on background | 4.5:1 minimum     | AA              |
| Large text (18px+)      | 3:1 minimum       | AA              |
| Interactive elements    | 3:1 minimum       | AA              |
| Focus indicators        | 3:1 minimum       | AA              |
| Error states            | Color + icon/text | Not color alone |

### Text & Typography

| Requirement    | Implementation                        |
| -------------- | ------------------------------------- |
| Dynamic type   | Support iOS/Android system font sizes |
| Minimum size   | 14px for readable content             |
| Line height    | 1.5x font size minimum                |
| Letter spacing | Normal or wider, never condensed      |
| Font weight    | Regular (400) minimum for body        |

### Visual Indicators

- Never rely on color alone for information
- Include icons with color-coded states
- Provide text labels for status indicators
- Pattern/texture alternatives for charts

---

## 3. Motor Accessibility

### Touch Targets

| Element             | Minimum Size     | Spacing     |
| ------------------- | ---------------- | ----------- |
| Buttons             | 44x44px          | 8px between |
| List items          | 48px height      | None needed |
| Icons (interactive) | 44x44px tap area | 8px between |
| Form inputs         | 48px height      | 8px between |

### Gestures

| Gesture         | Alternative                   |
| --------------- | ----------------------------- |
| Swipe to delete | Delete button in context menu |
| Pull to refresh | Refresh button visible        |
| Long press      | Three-dot menu alternative    |
| Pinch to zoom   | Zoom buttons where applicable |

---

## 4. Screen Reader Support

### VoiceOver (iOS) & TalkBack (Android)

| Requirement                      | Implementation                    |
| -------------------------------- | --------------------------------- |
| All interactive elements labeled | Semantic labels in Arabic/English |
| Images have alt text             | Decorative images marked hidden   |
| Forms have associated labels     | Label linked to input             |
| Error messages announced         | Live regions for dynamic updates  |
| Custom controls accessible       | AccessibilityDelegate implemented |

### Navigation

| Requirement        | Implementation                   |
| ------------------ | -------------------------------- |
| Logical tab order  | Follows visual order (RTL aware) |
| Skip to content    | Skip link where applicable       |
| Headings structure | Proper heading hierarchy         |
| Landmarks          | Regions for main areas           |

### Arabic VoiceOver Considerations

| Item              | Note                                                     |
| ----------------- | -------------------------------------------------------- |
| Reading direction | RTL announced correctly                                  |
| Numbers           | Read in correct order (left-to-right for numbers in RTL) |
| Currency          | "500 ريال سعودي" format                                  |
| Dates             | "15 ديسمبر 2025" format                                  |

---

## 5. Localization

### Supported Languages

| Language          | Code | Direction | Priority |
| ----------------- | ---- | --------- | -------- |
| Arabic (Standard) | ar   | RTL       | P0       |
| English           | en   | LTR       | P0       |
| French            | fr   | LTR       | P2       |

### RTL Implementation

| Element        | RTL Behavior                            |
| -------------- | --------------------------------------- |
| Layout         | Mirrored (start→end becomes right→left) |
| Navigation     | Flows right to left                     |
| Icons          | Directional icons mirrored              |
| Text alignment | Right by default for Arabic             |
| Numbers        | LTR embedding within RTL                |
| Forms          | Labels on right                         |

### Date & Calendar

| Locale | Calendar          | Format     |
| ------ | ----------------- | ---------- |
| ar-SA  | Hijri + Gregorian | DD/MM/YYYY |
| ar-AE  | Gregorian         | DD/MM/YYYY |
| en     | Gregorian         | DD/MM/YYYY |

### Numbers & Currency

| Locale | Numerals                | Currency Format |
| ------ | ----------------------- | --------------- |
| ar-SA  | Western (1,2,3) default | ر.س 1,000.00    |
| ar-EG  | Western (1,2,3) default | ج.م 1,000.00    |
| en     | Western                 | SAR 1,000.00    |

### Currency Support (22 Arab Currencies)

| Country      | Currency | Code | Symbol |
| ------------ | -------- | ---- | ------ |
| Saudi Arabia | Riyal    | SAR  | ر.س    |
| UAE          | Dirham   | AED  | د.إ    |
| Egypt        | Pound    | EGP  | ج.م    |
| Kuwait       | Dinar    | KWD  | د.ك    |
| Qatar        | Riyal    | QAR  | ر.ق    |
| Bahrain      | Dinar    | BHD  | د.ب    |
| Oman         | Riyal    | OMR  | ر.ع    |
| Jordan       | Dinar    | JOD  | د.أ    |
| Lebanon      | Pound    | LBP  | ل.ل    |
| ...          | ...      | ...  | ...    |

---

## 6. Internationalization (i18n)

### String Management

| Requirement              | Implementation                   |
| ------------------------ | -------------------------------- |
| All strings externalized | ARB files (Flutter)              |
| No hardcoded text        | i18n keys only                   |
| Plural support           | ICU message format               |
| Gender support           | Where grammatically needed       |
| Context support          | Same word, different translation |

### Dynamic Content

| Content Type    | Approach                |
| --------------- | ----------------------- |
| User-generated  | Display as-is (Unicode) |
| System messages | Localized               |
| Error messages  | Localized with codes    |
| Help content    | Localized or fallback   |

---

## 7. Testing Requirements

### Accessibility Testing

| Test Type           | Tool                       | Frequency   |
| ------------------- | -------------------------- | ----------- |
| Automated           | axe, flutter_accessibility | Every PR    |
| Manual VoiceOver    | iOS device                 | Per feature |
| Manual TalkBack     | Android device             | Per feature |
| Color contrast      | WebAIM Contrast Checker    | Per design  |
| Keyboard navigation | Desktop web                | Per feature |

### Localization Testing

| Test Type           | Approach                  |
| ------------------- | ------------------------- |
| String coverage     | 100% translation check    |
| RTL layout          | Visual regression testing |
| Currency formatting | Unit tests per currency   |
| Date formatting     | Unit tests per locale     |
| Pseudo-localization | Detect hardcoded strings  |

---

**Document Control:**

- Prepared by: Basir Development Agent Team
- Date: December 27, 2025
