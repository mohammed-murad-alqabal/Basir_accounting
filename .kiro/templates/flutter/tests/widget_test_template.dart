/// Widget Test Template - ${WIDGET_NAME}
/// 
/// المشروع: بصير MVP
/// المؤلف: فريق وكلاء تطوير مشروع بصير
/// 
/// يختبر: ${WIDGET_NAME} Widget
/// 
/// هذا القالب يوفر هيكل موحد لاختبارات الـ widgets مع:
/// - إعداد MaterialApp مناسب
/// - دعم الـ localization
/// - اختبار التفاعلات
/// - اختبار الحالات المختلفة

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Import the widget under test
// import 'package:basir_app/path/to/${WIDGET_NAME}.dart';

// Import test helpers
import '../../helpers/test_helpers.dart';

void main() {
  group('${WIDGET_NAME} Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = TestHelpers.createTestContainer();
    });

    tearDown(() {
      TestHelpers.cleanupTestContainer(container);
    });

    /// Helper function to create the widget under test
    Widget createTestWidget({
      ${WIDGET_PARAMETERS}
    }) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'SA'), // Arabic
            Locale('en', 'US'), // English
          ],
          locale: const Locale('ar', 'SA'),
          home: Scaffold(
            body: ${WIDGET_NAME}(
              ${WIDGET_CONSTRUCTOR_PARAMS}
            ),
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render without errors', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(${WIDGET_NAME}), findsOneWidget);
      });

      testWidgets('should display required elements', (WidgetTester tester) async {
        // Arrange
        const testData = ${TEST_DATA};

        // Act
        await tester.pumpWidget(createTestWidget(${TEST_PARAMETERS}));

        // Assert
        expect(find.text(${EXPECTED_TEXT}), findsOneWidget);
        expect(find.byType(${EXPECTED_WIDGET_TYPE}), findsOneWidget);
        expect(find.byIcon(${EXPECTED_ICON}), findsOneWidget);
      });

      testWidgets('should handle null/empty data gracefully', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget(${NULL_PARAMETERS}));

        // Assert
        expect(find.text(${EMPTY_STATE_TEXT}), findsOneWidget);
        expect(find.byType(${WIDGET_NAME}), findsOneWidget);
      });
    });

    group('User Interactions', () {
      testWidgets('should respond to tap events', (WidgetTester tester) async {
        // Arrange
        bool wasPressed = false;
        void onPressed() => wasPressed = true;

        // Act
        await tester.pumpWidget(createTestWidget(
          ${ON_PRESSED_PARAMETER}: onPressed,
        ));
        
        await tester.tap(find.byType(${TAPPABLE_WIDGET_TYPE}));
        await tester.pump();

        // Assert
        expect(wasPressed, isTrue);
      });

      testWidgets('should handle long press events', (WidgetTester tester) async {
        // Arrange
        bool wasLongPressed = false;
        void onLongPress() => wasLongPressed = true;

        // Act
        await tester.pumpWidget(createTestWidget(
          ${ON_LONG_PRESS_PARAMETER}: onLongPress,
        ));
        
        await tester.longPress(find.byType(${TAPPABLE_WIDGET_TYPE}));
        await tester.pump();

        // Assert
        expect(wasLongPressed, isTrue);
      });

      testWidgets('should not respond when disabled', (WidgetTester tester) async {
        // Arrange
        bool wasPressed = false;
        void onPressed() => wasPressed = true;

        // Act
        await tester.pumpWidget(createTestWidget(
          ${ON_PRESSED_PARAMETER}: onPressed,
          ${ENABLED_PARAMETER}: false,
        ));
        
        await tester.tap(find.byType(${TAPPABLE_WIDGET_TYPE}));
        await tester.pump();

        // Assert
        expect(wasPressed, isFalse);
      });
    });

    group('State Changes', () {
      testWidgets('should update when data changes', (WidgetTester tester) async {
        // Arrange
        const initialData = ${INITIAL_DATA};
        const updatedData = ${UPDATED_DATA};

        // Act - Initial render
        await tester.pumpWidget(createTestWidget(${INITIAL_PARAMETERS}));
        expect(find.text(${INITIAL_TEXT}), findsOneWidget);

        // Act - Update data
        await tester.pumpWidget(createTestWidget(${UPDATED_PARAMETERS}));
        await tester.pump();

        // Assert
        expect(find.text(${UPDATED_TEXT}), findsOneWidget);
        expect(find.text(${INITIAL_TEXT}), findsNothing);
      });

      testWidgets('should show loading state', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget(
          ${IS_LOADING_PARAMETER}: true,
        ));

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text(${LOADING_TEXT}), findsOneWidget);
      });

      testWidgets('should show error state', (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Test error message';

        // Act
        await tester.pumpWidget(createTestWidget(
          ${ERROR_PARAMETER}: errorMessage,
        ));

        // Assert
        expect(find.text(errorMessage), findsOneWidget);
        expect(find.byIcon(Icons.error), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should have proper semantics', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(
          tester.getSemantics(find.byType(${WIDGET_NAME})),
          matchesSemantics(
            label: ${SEMANTIC_LABEL},
            hint: ${SEMANTIC_HINT},
            isButton: ${IS_BUTTON},
            isEnabled: ${IS_ENABLED},
          ),
        );
      });

      testWidgets('should support screen readers', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final semantics = tester.getSemantics(find.byType(${WIDGET_NAME}));
        expect(semantics.label, isNotNull);
        expect(semantics.label, isNotEmpty);
      });

      testWidgets('should have minimum touch target size', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        final renderBox = tester.renderObject(find.byType(${WIDGET_NAME})) as RenderBox;
        expect(renderBox.size.width, greaterThanOrEqualTo(48.0));
        expect(renderBox.size.height, greaterThanOrEqualTo(48.0));
      });
    });

    group('Theming and Styling', () {
      testWidgets('should apply custom theme', (WidgetTester tester) async {
        // Arrange
        final customTheme = ThemeData(
          primarySwatch: Colors.red,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 20),
          ),
        );

        // Act
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: customTheme,
              home: Scaffold(
                body: ${WIDGET_NAME}(${WIDGET_CONSTRUCTOR_PARAMS}),
              ),
            ),
          ),
        );

        // Assert
        final widget = tester.widget<${WIDGET_NAME}>(find.byType(${WIDGET_NAME}));
        // Add theme-specific assertions here
      });

      testWidgets('should support RTL layout', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: const Locale('ar', 'SA'),
              home: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  body: ${WIDGET_NAME}(${WIDGET_CONSTRUCTOR_PARAMS}),
                ),
              ),
            ),
          ),
        );

        // Assert
        final directionality = tester.widget<Directionality>(
          find.ancestor(
            of: find.byType(${WIDGET_NAME}),
            matching: find.byType(Directionality),
          ),
        );
        expect(directionality.textDirection, TextDirection.rtl);
      });
    });

    group('Performance', () {
      testWidgets('should not rebuild unnecessarily', (WidgetTester tester) async {
        // Arrange
        int buildCount = 0;
        
        Widget countingWidget() {
          return Builder(
            builder: (context) {
              buildCount++;
              return ${WIDGET_NAME}(${WIDGET_CONSTRUCTOR_PARAMS});
            },
          );
        }

        // Act
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: countingWidget())),
        );
        
        // Trigger a rebuild that shouldn't affect our widget
        await tester.pump();

        // Assert
        expect(buildCount, equals(1));
      });

      testWidgets('should handle large datasets efficiently', (WidgetTester tester) async {
        // Arrange
        final largeDataset = List.generate(1000, (index) => 'Item $index');

        // Act
        final stopwatch = Stopwatch()..start();
        await tester.pumpWidget(createTestWidget(
          ${DATA_PARAMETER}: largeDataset,
        ));
        stopwatch.stop();

        // Assert
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // < 1 second
        expect(find.byType(${WIDGET_NAME}), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle widget disposal gracefully', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        await tester.pumpWidget(Container()); // Remove the widget

        // Assert - No exceptions should be thrown
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle rapid state changes', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());
        
        // Rapidly change state multiple times
        for (int i = 0; i < 10; i++) {
          await tester.pumpWidget(createTestWidget(${CHANGING_PARAMETER}: i));
          await tester.pump(Duration(milliseconds: 10));
        }

        // Assert
        expect(find.byType(${WIDGET_NAME}), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });
  });
}

// ═══════════════════════════════════════════════════════════════════════════════════
// Template Variables (replace when using this template):
// ═══════════════════════════════════════════════════════════════════════════════════
// 
// ${WIDGET_NAME} - اسم الـ Widget (مثل: CustomerCard)
// ${WIDGET_PARAMETERS} - معاملات الـ Widget (مثل: Customer? customer, VoidCallback? onTap)
// ${WIDGET_CONSTRUCTOR_PARAMS} - معاملات الـ constructor (مثل: customer: testCustomer, onTap: onTap)
// ${TEST_PARAMETERS} - معاملات الاختبار (مثل: customer: testData)
// ${TEST_DATA} - بيانات الاختبار (مثل: Customer(name: 'Test Customer'))
// ${EXPECTED_TEXT} - النص المتوقع (مثل: 'Test Customer')
// ${EXPECTED_WIDGET_TYPE} - نوع الـ Widget المتوقع (مثل: Card)
// ${EXPECTED_ICON} - الأيقونة المتوقعة (مثل: Icons.person)
// ${NULL_PARAMETERS} - معاملات null (مثل: customer: null)
// ${EMPTY_STATE_TEXT} - نص الحالة الفارغة (مثل: 'لا توجد بيانات')
// ${ON_PRESSED_PARAMETER} - معامل onPressed (مثل: onTap)
// ${TAPPABLE_WIDGET_TYPE} - نوع الـ Widget القابل للنقر (مثل: InkWell)
// ${ON_LONG_PRESS_PARAMETER} - معامل onLongPress
// ${ENABLED_PARAMETER} - معامل enabled
// ${INITIAL_DATA} - البيانات الأولية
// ${UPDATED_DATA} - البيانات المحدثة
// ${INITIAL_PARAMETERS} - المعاملات الأولية
// ${UPDATED_PARAMETERS} - المعاملات المحدثة
// ${INITIAL_TEXT} - النص الأولي
// ${UPDATED_TEXT} - النص المحدث
// ${IS_LOADING_PARAMETER} - معامل isLoading
// ${LOADING_TEXT} - نص التحميل
// ${ERROR_PARAMETER} - معامل error
// ${SEMANTIC_LABEL} - تسمية semantic
// ${SEMANTIC_HINT} - تلميح semantic
// ${IS_BUTTON} - هل هو زر (true/false)
// ${IS_ENABLED} - هل هو مفعل (true/false)
// ${DATA_PARAMETER} - معامل البيانات
// ${CHANGING_PARAMETER} - معامل متغير