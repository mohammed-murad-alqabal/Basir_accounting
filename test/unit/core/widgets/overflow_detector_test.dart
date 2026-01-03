import 'package:basir_app/shared/widgets/overflow_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverflowDetector Widget', () {
    testWidgets('should render child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: OverflowDetector(child: Text('Test Text'))),
        ),
      );

      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('should not show warning for normal content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200,
              height: 100,
              child: OverflowDetector(child: Text('Short text')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('OVERFLOW'), findsNothing);
    });

    testWidgets('should accept custom name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OverflowDetector(name: 'TestWidget', child: Text('Test')),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should respect showVisualWarning parameter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 50,
              height: 20,
              child: OverflowDetector(
                showVisualWarning: false,
                child: Text('Very long text that will overflow'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // لا يجب أن يظهر التحذير البصري
      expect(find.text('OVERFLOW'), findsNothing);
    });
  });

  group('OverflowDetectorHelper', () {
    group('willTextOverflow', () {
      test('should detect overflow for long text', () {
        const text = 'This is a very long text that will definitely overflow';
        const style = TextStyle(fontSize: 16);
        const maxWidth = 50.0;

        final willOverflow = OverflowDetectorHelper.willTextOverflow(
          text: text,
          style: style,
          maxWidth: maxWidth,
          maxLines: 1,
        );

        expect(willOverflow, true);
      });

      test('should not detect overflow for short text', () {
        const text = 'Short';
        const style = TextStyle(fontSize: 16);
        const maxWidth = 200.0;

        final willOverflow = OverflowDetectorHelper.willTextOverflow(
          text: text,
          style: style,
          maxWidth: maxWidth,
          maxLines: 1,
        );

        expect(willOverflow, false);
      });

      test('should handle multiple lines', () {
        const text = 'Short text';
        const style = TextStyle(fontSize: 16);
        const maxWidth = 200.0;

        final willOverflow = OverflowDetectorHelper.willTextOverflow(
          text: text,
          style: style,
          maxWidth: maxWidth,
          maxLines: 3,
        );

        // نص قصير مع 3 أسطر، يجب ألا يكون هناك overflow
        expect(willOverflow, false);
      });
    });

    group('calculateTextWidth', () {
      test('should calculate width for text', () {
        const text = 'Test';
        const style = TextStyle(fontSize: 16);

        final width = OverflowDetectorHelper.calculateTextWidth(
          text: text,
          style: style,
        );

        expect(width, greaterThan(0));
        expect(width, lessThan(100)); // نص قصير
      });

      test('should return larger width for longer text', () {
        const shortText = 'Hi';
        const longText = 'This is a much longer text';
        const style = TextStyle(fontSize: 16);

        final shortWidth = OverflowDetectorHelper.calculateTextWidth(
          text: shortText,
          style: style,
        );

        final longWidth = OverflowDetectorHelper.calculateTextWidth(
          text: longText,
          style: style,
        );

        expect(longWidth, greaterThan(shortWidth));
      });

      test('should increase width with larger font size', () {
        const text = 'Test';
        const smallStyle = TextStyle(fontSize: 12);
        const largeStyle = TextStyle(fontSize: 24);

        final smallWidth = OverflowDetectorHelper.calculateTextWidth(
          text: text,
          style: smallStyle,
        );

        final largeWidth = OverflowDetectorHelper.calculateTextWidth(
          text: text,
          style: largeStyle,
        );

        expect(largeWidth, greaterThan(smallWidth));
      });
    });

    group('calculateTextHeight', () {
      test('should calculate height for text', () {
        const text = 'Test';
        const style = TextStyle(fontSize: 16);
        const maxWidth = 200.0;

        final height = OverflowDetectorHelper.calculateTextHeight(
          text: text,
          style: style,
          maxWidth: maxWidth,
        );

        expect(height, greaterThan(0));
      });

      test('should increase height for wrapped text', () {
        const text = 'This is a long text that will wrap to multiple lines';
        const style = TextStyle(fontSize: 16);
        const narrowWidth = 100.0;
        const wideWidth = 500.0;

        final narrowHeight = OverflowDetectorHelper.calculateTextHeight(
          text: text,
          style: style,
          maxWidth: narrowWidth,
        );

        final wideHeight = OverflowDetectorHelper.calculateTextHeight(
          text: text,
          style: style,
          maxWidth: wideWidth,
        );

        expect(narrowHeight, greaterThan(wideHeight));
      });

      test('should respect maxLines', () {
        const text = 'Line 1\nLine 2\nLine 3\nLine 4';
        const style = TextStyle(fontSize: 16);
        const maxWidth = 200.0;

        final unlimitedHeight = OverflowDetectorHelper.calculateTextHeight(
          text: text,
          style: style,
          maxWidth: maxWidth,
        );

        final limitedHeight = OverflowDetectorHelper.calculateTextHeight(
          text: text,
          style: style,
          maxWidth: maxWidth,
          maxLines: 2,
        );

        expect(limitedHeight, lessThan(unlimitedHeight));
      });
    });

    group('checkTextFit', () {
      test('should return fits=true for text that fits', () {
        const text = 'Short';
        const style = TextStyle(fontSize: 16);
        const availableWidth = 200.0;
        const availableHeight = 100.0;

        final result = OverflowDetectorHelper.checkTextFit(
          text: text,
          style: style,
          availableWidth: availableWidth,
          availableHeight: availableHeight,
        );

        expect(result['fits'], true);
        expect(result['fitsHorizontally'], true);
        expect(result['fitsVertically'], true);
      });

      test('should return fits=false for text that overflows', () {
        const text = 'This is a very long text that will overflow';
        const style = TextStyle(fontSize: 16);
        const availableWidth = 50.0;
        const availableHeight = 20.0;

        final result = OverflowDetectorHelper.checkTextFit(
          text: text,
          style: style,
          availableWidth: availableWidth,
          availableHeight: availableHeight,
          maxLines: 1,
        );

        expect(result['fits'], false);
      });

      test('should provide overflow measurements', () {
        const text = 'Overflow text';
        const style = TextStyle(fontSize: 16);
        const availableWidth = 50.0;
        const availableHeight = 100.0;

        final result = OverflowDetectorHelper.checkTextFit(
          text: text,
          style: style,
          availableWidth: availableWidth,
          availableHeight: availableHeight,
          maxLines: 1,
        );

        expect(result['requiredWidth'], greaterThan(0));
        expect(result['requiredHeight'], greaterThan(0));
        expect(result['horizontalOverflow'], isA<double>());
        expect(result['verticalOverflow'], isA<double>());
      });

      test('should detect maxLines exceeded', () {
        const text = 'Line 1\nLine 2\nLine 3';
        const style = TextStyle(fontSize: 16);
        const availableWidth = 200.0;
        const availableHeight = 100.0;

        final result = OverflowDetectorHelper.checkTextFit(
          text: text,
          style: style,
          availableWidth: availableWidth,
          availableHeight: availableHeight,
          maxLines: 2,
        );

        expect(result['exceedsMaxLines'], true);
      });

      test('should include all required fields', () {
        const text = 'Test';
        const style = TextStyle(fontSize: 16);
        const availableWidth = 200.0;
        const availableHeight = 100.0;

        final result = OverflowDetectorHelper.checkTextFit(
          text: text,
          style: style,
          availableWidth: availableWidth,
          availableHeight: availableHeight,
        );

        expect(result, containsPair('fits', isA<bool>()));
        expect(result, containsPair('fitsHorizontally', isA<bool>()));
        expect(result, containsPair('fitsVertically', isA<bool>()));
        expect(result, containsPair('exceedsMaxLines', isA<bool>()));
        expect(result, containsPair('requiredWidth', isA<double>()));
        expect(result, containsPair('requiredHeight', isA<double>()));
        expect(result, containsPair('availableWidth', isA<double>()));
        expect(result, containsPair('availableHeight', isA<double>()));
        expect(result, containsPair('horizontalOverflow', isA<double>()));
        expect(result, containsPair('verticalOverflow', isA<double>()));
      });
    });
  });
}
