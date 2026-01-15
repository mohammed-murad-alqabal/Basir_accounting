import 'dart:async';

import 'package:basir_accounting_system/core/extensions/context_extensions.dart';
import 'package:basir_accounting_system/core/theme/tokens/index.dart';
import 'package:basir_accounting_system/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

/// 💎 شاشة الحاسبة المالية (Financial Calculator Screen Platinum)
/// واجهة متطورة للحسابات السريعة مع دعم تحويل العملات
class FinancialCalculatorScreen extends StatefulWidget {
  /// إنشاء شاشة الحاسبة المالية
  const FinancialCalculatorScreen({super.key});

  @override
  State<FinancialCalculatorScreen> createState() =>
      _FinancialCalculatorScreenState();
}

class _FinancialCalculatorScreenState extends State<FinancialCalculatorScreen> {
  String _display = '';
  String _result = '';
  bool _useCurrencies = false;
  final List<String> _history = [];
  final double _usdRate = 3.75; // SAR to USD Fixed Rate

  void _onPressed(String text) {
    setState(() {
      if (text == 'C') {
        _display = '';
        _result = '';
      } else if (text == '=') {
        _calculate();
      } else if (text == '%') {
        if (_display.isNotEmpty) {
          _display += '/100';
          _calculate();
        }
      } else {
        _display += text;
      }
    });
  }

  void _calculate() {
    if (_display.isEmpty) return;
    try {
      final p = GrammarParser();
      final exp = p.parse(_display.replaceAll('X', '*'));
      final cm = ContextModel();
      final eval = exp.evaluate(EvaluationType.REAL, cm);

      var finalResult = eval.toString();
      if (_useCurrencies) {
        final usdVal = (eval as num).toDouble() / _usdRate;
        finalResult =
            '${eval.toStringAsFixed(2)} SAR ≈ ${usdVal.toStringAsFixed(2)} USD';
      }

      setState(() {
        _result = finalResult;
        _history.insert(0, '$_display = $_result');
        if (_history.length > 10) {
          _history.removeLast();
        }
      });
    } on Exception {
      setState(() {
        _result = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return GlassScaffold(
      title: l10n.calculatorTitle,
      body: Column(
        children: [
          // 📺 منطقة العرض
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.xl),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_history.isNotEmpty)
                    GestureDetector(
                      onTap: () => _showHistory(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(Radii.sm),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.history,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.auditTrailTitle, // Reusing localized string
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Spacer(),
                  Text(
                    _display,
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    _result,
                    style: theme.textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // ⚙️ خيارات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            child: Row(
              children: [
                Checkbox(
                  value: _useCurrencies,
                  onChanged: (val) => setState(() => _useCurrencies = val!),
                ),
                Text(l10n.convertToCurrencies),
              ],
            ),
          ),

          // 🎹 لوحة المفاتيح
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                children: [
                  _buildRow(['/', '(', ')', 'C'], isSpecial: true),
                  _buildRow(['7', '8', '9', 'X']),
                  _buildRow(['4', '5', '6', '-']),
                  _buildRow(['1', '2', '3', '+']),
                  _buildRow(['%', '0', '.', '='], isAction: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    List<String> buttons, {
    bool isSpecial = false,
    bool isAction = false,
  }) =>
      Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttons
              .map(
                (b) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.xs),
                    child: AppEnhancedButton(
                      label: b,
                      type: _getButtonType(b, isSpecial, isAction),
                      onPressed: () => _onPressed(b),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

  AppEnhancedButtonType _getButtonType(
    String b,
    bool isSpecial,
    bool isAction,
  ) {
    if (b == 'C') return AppEnhancedButtonType.danger;
    if (b == '=') return AppEnhancedButtonType.primary;
    if (['/', 'X', '-', '+', '(', ')'].contains(b)) {
      return AppEnhancedButtonType.secondary;
    }
    return AppEnhancedButtonType.outlined;
  }

  void _showHistory(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => GlassCard(
          margin: const EdgeInsets.all(Spacing.md),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(Spacing.md),
                child: Text(
                  context.l10n.auditTrailTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(_history[index]),
                    onTap: () {
                      final parts = _history[index].split(' = ');
                      setState(() {
                        _display = parts[0];
                        _result = parts[1];
                      });
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
