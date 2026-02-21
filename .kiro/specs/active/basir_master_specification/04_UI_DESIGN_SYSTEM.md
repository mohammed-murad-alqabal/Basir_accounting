# UI/UX Design System Specification

**Version:** 2.0 (Sovereign Edition)
**Basis:** Glassmorphism Implementation & Legacy Visuals
**Scope:** Design Tokens, Component Library, Interaction Patterns

---

## 1. Design Philosophy: The Diamond Experience

The Basir UI is built on the **Glassmorphism** design language, creating a modern, premium, and intuitive experience.

### 1.1 Core Aesthetic Principles

| Principle                | Implementation                                   |
| ------------------------ | ------------------------------------------------ |
| **Depth Through Blur**   | `BackdropFilter` with blur radius 15-20px        |
| **Layered Transparency** | Cards use 10-20% opacity on dark backgrounds     |
| **Subtle Borders**       | 1px borders with 20% opacity for edge definition |
| **Smooth Animations**    | Spring physics for transitions (200-400ms)       |
| **Premium Typography**   | Inter/Roboto font families, clear hierarchy      |

---

## 2. Design Tokens

### 2.1 Color Palette (`lib/core/theme/tokens/color_tokens.dart`)

| Token           | Light Mode        | Dark Mode | Usage                    |
| --------------- | ----------------- | --------- | ------------------------ |
| `primary`       | `#009688` (Teal)  | `#26A69A` | Primary actions, headers |
| `primaryDark`   | `#00796B`         | `#00897B` | AppBar, navigation       |
| `secondary`     | `#FFB74D` (Amber) | `#FFB74D` | Accents, warnings        |
| `surface`       | `#FFFFFF`         | `#1E1E2E` | Card backgrounds         |
| `background`    | `#F5F5F5`         | `#121218` | Scaffold background      |
| `textPrimary`   | `#212121`         | `#ECEFF4` | Body text                |
| `textSecondary` | `#757575`         | `#8E8E93` | Captions, hints          |
| `success`       | `#4CAF50`         | `#66BB6A` | Positive indicators      |
| `error`         | `#F44336`         | `#EF5350` | Negative indicators      |
| `warning`       | `#FF9800`         | `#FFA726` | Alerts                   |

### 2.2 Typography Scale (`lib/core/theme/tokens/typography_tokens.dart`)

| Token            | Size | Weight   | Line Height |
| ---------------- | ---- | -------- | ----------- |
| `headlineLarge`  | 32sp | Bold     | 1.2         |
| `headlineMedium` | 28sp | Bold     | 1.2         |
| `headlineSmall`  | 24sp | SemiBold | 1.3         |
| `titleLarge`     | 20sp | SemiBold | 1.4         |
| `titleMedium`    | 16sp | Medium   | 1.4         |
| `titleSmall`     | 14sp | Medium   | 1.4         |
| `bodyLarge`      | 16sp | Regular  | 1.5         |
| `bodyMedium`     | 14sp | Regular  | 1.5         |
| `bodySmall`      | 12sp | Regular  | 1.5         |
| `labelLarge`     | 14sp | Medium   | 1.2         |
| `labelMedium`    | 12sp | Medium   | 1.2         |
| `labelSmall`     | 10sp | Medium   | 1.1         |

### 2.3 Spacing Scale (`lib/core/theme/tokens/spacing_tokens.dart`)

| Token | Value | Usage             |
| ----- | ----- | ----------------- |
| `xxs` | 2px   | Micro gaps        |
| `xs`  | 4px   | Icon-text spacing |
| `sm`  | 8px   | Inline elements   |
| `md`  | 12px  | Section dividers  |
| `lg`  | 16px  | Card padding      |
| `xl`  | 24px  | Section gaps      |
| `xxl` | 32px  | Page margins      |

### 2.4 Radii (`lib/core/theme/tokens/spacing_tokens.dart`)

| Token  | Value  | Usage                |
| ------ | ------ | -------------------- |
| `xs`   | 4px    | Small buttons, chips |
| `sm`   | 8px    | Standard cards       |
| `md`   | 12px   | Modals               |
| `lg`   | 16px   | Feature cards        |
| `xl`   | 24px   | Hero elements        |
| `full` | 9999px | Pills, avatars       |

---

## 3. Core Component Library

### 3.1 `GlassScaffold` (`lib/shared/widgets/glass_scaffold.dart`)

The primary screen wrapper, providing consistent structure.

```dart
GlassScaffold(
  title: 'Invoice',
  actions: [IconButton(...)],
  body: YourContent(),
)
```

**Features:**

- Gradient background (dark mode: deep blue to black)
- Glassmorphic AppBar with blur
- Consistent padding and safe areas

### 3.2 `GlassCard` (`lib/shared/widgets/glass_card.dart`)

The primary container for content groups.

```dart
GlassCard(
  padding: EdgeInsets.all(Spacing.lg),
  child: Column(...),
)
```

**Features:**

- Semi-transparent background with blur
- Subtle border for depth
- Customizable `borderRadius` and `margin`

### 3.3 `AppTextField` (`lib/shared/widgets/app_text_field.dart`)

Standardized text input with Glassmorphic styling.

```dart
AppTextField(
  label: 'Description',
  controller: _controller,
  validator: (v) => v!.isEmpty ? 'Required' : null,
)
```

### 3.4 `AppEnhancedButton` (`lib/shared/widgets/app_button.dart`)

Premium button with loading state and icon support.

```dart
AppEnhancedButton(
  label: 'Post Entry',
  icon: Icons.check,
  isLoading: _isPosting,
  onPressed: _handlePost,
)
```

**Variants:** `primary`, `secondary`, `danger`, `ghost`

### 3.5 `AppDropdown` (`lib/shared/widgets/app_dropdown.dart`)

Consistent dropdown selection component.

---

## 4. Interaction Patterns

### 4.1 Navigation: `SpringRoute`

All screen transitions use spring-based animations for a fluid feel.

```dart
Navigator.of(context).push(SpringRoute(builder: (_) => TargetScreen()));
```

### 4.2 Cognitive Overlay

First-time users receive contextual hints via `CognitiveOverlay`.

```dart
showCognitiveHint(
  context: context,
  target: _formKey,
  title: 'Pro Tip',
  message: 'Double-tap an item to edit it.',
);
```

### 4.3 Loading States

All asynchronous operations display a shimmer effect or `CircularProgressIndicator` within the action button.

### 4.4 Error Handling

Errors are displayed via `SnackBar` with clear, actionable messages.

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Error: Invoice could not be saved.'),
    backgroundColor: AppColors.error,
  ),
);
```

---

## 5. Responsive Design

### 5.1 Breakpoints

| Breakpoint | Width      | Target                 |
| ---------- | ---------- | ---------------------- |
| Mobile     | < 600px    | Phones                 |
| Tablet     | 600-1024px | Tablets, small laptops |
| Desktop    | > 1024px   | Desktops, dashboards   |

### 5.2 Layout Adaptation

- **Mobile:** Single-column layouts, bottom navigation.
- **Tablet:** Split views (master-detail), side drawers.
- **Desktop:** Full dashboards with persistent navigation rails.

---

## 6. Accessibility (a11y)

| Requirement         | Implementation                            |
| ------------------- | ----------------------------------------- |
| **Color Contrast**  | WCAG AA (4.5:1 for text)                  |
| **Touch Targets**   | Minimum 44x44px                           |
| **Semantic Labels** | All icons and images have `semanticLabel` |
| **Screen Reader**   | Key flows tested with TalkBack/VoiceOver  |

---

## 7. Icon Library (`lib/core/icons/app_icons.dart`)

A curated set of icons for consistent visual language.

| Icon                    | Usage          |
| ----------------------- | -------------- |
| `Icons.receipt_long`    | Invoices       |
| `Icons.inventory_2`     | Inventory      |
| `Icons.account_balance` | Accounting, GL |
| `Icons.bar_chart`       | Reports        |
| `Icons.settings`        | Settings       |
| `Icons.lock`            | Locked periods |
| `Icons.lock_open`       | Open periods   |
| `Icons.verified_user`   | Compliance     |

---

_This design system ensures a consistent, premium, and accessible user experience across all Basir modules._
