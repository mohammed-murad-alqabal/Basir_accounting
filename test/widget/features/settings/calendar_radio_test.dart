// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:basir_accounting_system/core/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Calendar Radio Logic Isolated Test', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                final calendarType =
                    ref.watch(calendarProvider).value ?? CalendarType.gregorian;
                return Column(
                  children: [
                    RadioListTile<CalendarType>(
                      key: const Key('calendar_option_gregorian'),
                      title: const Text('Gregorian'),
                      value: CalendarType.gregorian,
                      // ignore: deprecated_member_use
                      groupValue: calendarType,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        if (value != null) {
                          unawaited(
                            ref
                                .read(calendarProvider.notifier)
                                .setCalendarType(value),
                          );
                        }
                      },
                    ),
                    RadioListTile<CalendarType>(
                      key: const Key('calendar_option_hijri'),
                      title: const Text('Hijri'),
                      value: CalendarType.hijri,
                      // ignore: deprecated_member_use
                      groupValue: calendarType,
                      // ignore: deprecated_member_use
                      onChanged: (value) {
                        if (value != null) {
                          unawaited(
                            ref
                                .read(calendarProvider.notifier)
                                .setCalendarType(value),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    // Verify initial
    expect(find.byKey(const Key('calendar_option_gregorian')), findsOneWidget);
    expect(find.byKey(const Key('calendar_option_hijri')), findsOneWidget);

    final type1 = await container.read(calendarProvider.future);
    expect(type1, CalendarType.gregorian);

    // Tap Hijri
    await tester.tap(find.byKey(const Key('calendar_option_hijri')));
    await tester.pumpAndSettle();

    // Verify update
    final type2 = await container.read(calendarProvider.future);
    expect(type2, CalendarType.hijri);
  });
}
