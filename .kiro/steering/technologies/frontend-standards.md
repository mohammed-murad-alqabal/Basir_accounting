**المشروع:** بصير MVP
**المؤلف:** فريق وكلاء تطوير مشروع بصير  
**المصدر:** مكيف من مصادر مجتمع Kiro المعتمدة
**التاريخ:** 10 December 2025

---

---

inclusion: fileMatch
fileMatchPattern: '_.tsx|_.jsx|_.vue|_.svelte'

---

# Frontend Development Standards

## Component Architecture

- Use StatelessWidget and StatefulWidget appropriately (Flutter)
- Keep widgets small and focused on single responsibilities
- Implement proper parameter validation
- Use Dart with strong typing for type safety
- Follow Flutter widget composition patterns

## State Management

- Use local state for component-specific data
- Implement global state for shared application data
- Use proper state management libraries (Redux, Zustand, Pinia)
- Avoid prop drilling with context or state management

## Styling Guidelines

- Use CSS modules or styled-components for component styling
- Follow BEM methodology for CSS class naming
- Implement responsive design with mobile-first approach
- Use CSS custom properties for theming
- Maintain consistent spacing and typography scales

## Performance Optimization

- Implement code splitting and lazy loading
- Use const constructors and widgets for performance optimization
- Optimize images and assets for mobile platforms
- Implement proper state management with Riverpod
- Monitor app size and performance metrics with Flutter DevTools

## Accessibility Standards

- Use semantic HTML elements
- Implement proper ARIA attributes
- Ensure keyboard navigation support
- Maintain proper color contrast ratios
- Test with screen readers

## Testing Strategy

- Write unit tests for utility functions using Flutter Test
- Use Flutter Widget Testing for component tests
- Implement golden file testing for visual regression
- Test user interactions and workflows with integration tests
- Mock external dependencies using mockito package
