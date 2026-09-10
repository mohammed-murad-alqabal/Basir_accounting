# UI/UX Design System Specification

**Version:** 2.1 (Governed Token Baseline)
**Basis:** التنفيذ القائم وقرار `ADR-UX-001`؛ لا تعد القيم التاريخية للهوية مصدر حقيقة.
**Scope:** Design Tokens, Component Library, Interaction Patterns
**Canonical authority:** [`ADR-UX-001`](../../../docs/03-architecture/adrs/ADR-UX-001-canonical-design-tokens-and-runtime-overrides.md) ثم `lib/core/theme/tokens/` و`lib/core/theme/app_theme.dart`.

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
| **Premium Typography**   | Cairo عبر `GoogleFonts.cairoTextTheme`، مع hierarchy واضح      |

---

## 2. Design Tokens

### 2.1 Color Palette (`AppColors` + `AppPalette` + `AppTheme`)

`ADR-UX-001` هو القرار الحاكم لمصدر الرموز. تمثل `AppColors` الرموز الدلالية للوضع الفاتح والمشترك، وتمثل `AppPalette` primitives للوضع الداكن، بينما يبني `AppTheme` `ColorScheme` الافتراضي. لا تضع الشاشة قيمة brand مستقلة؛ تستهلك `Theme.of(context).colorScheme` أولًا أو token دلاليًا عند الحاجة المعزولة.

| Token / ColorScheme role | Light default source and value | Dark default source and value | Usage |
| --- | --- | --- | --- |
| `primary` | `AppColors.primary` — `#0056B3` | `AppPalette.blueCorporate` — `#2563EB` | Primary actions, navigation selection, priority links. |
| `primaryContainer` | `AppColors.primaryLight` — `#E3F2FD` | `AppPalette.navyDeep` — `#1E3A8A` | Tinted primary containers. |
| `onPrimaryContainer` | `AppColors.primaryDark` — `#003D82` | `AppPalette.blueLight` — `#BFDBFE` | Text and icons on primary containers. |
| `secondary` | `AppColors.secondary` — `#1E7E34` | `AppPalette.greenEmerald` — `#10B981` | Secondary action and positive supporting emphasis. |
| `surface` | `AppColors.surface` — `#FFFFFF` | `AppPalette.darkSurface` — `#1E293B` | Cards, input and dialog surfaces. |
| scaffold background | `AppColors.background` — `#F5F7FA` | `AppPalette.darkBackground` — `#0F172A` | Page background. |
| text / `onSurface` | `AppColors.onSurface` — `#212529` | `AppPalette.darkTextPrimary` — `#F1F5F9` | Body and heading text through `ColorScheme`. |
| `error` | `AppColors.error` — `#C62828` | `AppPalette.redAlert` — `#EF4444` | Negative indicators and errors; never use color alone for state. |
| warning | `AppColors.warning` — `#D73502` | No separate dark semantic token is approved. | Alerts that require text, icon, or border support. |

#### Runtime user color preference

`ColorCustomizationService` may provide a per-user `seedColor` to `AppTheme` at runtime. It is a local preference, **not** a product-brand token and must not be copied into this specification. Its current acceptance path does not yet prove contrast validation; therefore do not claim WCAG conformance for an arbitrary user-selected seed until `REQ-UX-002` receives dedicated validation and tests.

#### Planned brand evolution

The strategic value `#0F6E7D` remains a planned identity direction, not an implemented default. A future change requires the migration controls in `ADR-UX-001`: owner approval, one token-level implementation change, synchronized specification/documentation update, contract or visual test, and contrast evidence.

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
