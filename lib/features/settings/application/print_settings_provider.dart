// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unused_local_variable
// ignore_for_file: inference_failure_on_function_invocation
// ignore_for_file: discarded_futures
// ignore_for_file: deprecated_member_use
import 'package:basir_accounting_system/features/settings/domain/entities/print_settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'print_settings_provider.g.dart';

@riverpod
class PrintSettingsNotifier extends _$PrintSettingsNotifier {
  late SharedPreferences _prefs;

  @override
  PrintSettings build() {
    _initPrefs();
    return const PrintSettings(); // Return default while loading
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    loadSettings();
  }

  void loadSettings() {
    final paperSize = _prefs.getString('print_settings_paperSize') ?? '80mm';
    final template = _prefs.getString('print_settings_template') ?? 'A4';
    final fontSize = _prefs.getDouble('print_settings_fontSize') ?? 20.0;
    final paddingBottom = _prefs.getInt('print_settings_paddingBottom') ?? 7;
    final printCopies = _prefs.getInt('print_settings_printCopies') ?? 1;
    final showUnit = _prefs.getBool('print_settings_showUnit') ?? false;
    final printTwoCopies = _prefs.getBool('print_settings_printTwoCopies') ?? false;
    final fontType = _prefs.getString('print_settings_fontType') ?? '1';
    final customPaperSize = _prefs.getInt('print_settings_customPaperSize') ?? 375;
    final a4Template = _prefs.getInt('print_settings_a4Template') ?? 0;
    final bluetoothTemplate = _prefs.getInt('print_settings_bluetoothTemplate') ?? 0;
    final statementTemplate = _prefs.getInt('print_settings_statementTemplate') ?? 0;

    state = PrintSettings(
      paperSize: paperSize,
      template: template,
      fontSize: fontSize,
      paddingBottom: paddingBottom,
      printCopies: printCopies,
      showUnit: showUnit,
      printTwoCopies: printTwoCopies,
      fontType: fontType,
      customPaperSize: customPaperSize,
      a4Template: a4Template,
      bluetoothTemplate: bluetoothTemplate,
      statementTemplate: statementTemplate,
    );
  }

  Future<void> updateSettings(PrintSettings settings) async {
    await _prefs.setString('print_settings_paperSize', settings.paperSize);
    await _prefs.setString('print_settings_template', settings.template);
    await _prefs.setDouble('print_settings_fontSize', settings.fontSize);
    await _prefs.setInt('print_settings_paddingBottom', settings.paddingBottom);
    await _prefs.setInt('print_settings_printCopies', settings.printCopies);
    await _prefs.setBool('print_settings_showUnit', settings.showUnit);
    await _prefs.setBool('print_settings_printTwoCopies', settings.printTwoCopies);
    await _prefs.setString('print_settings_fontType', settings.fontType);
    await _prefs.setInt('print_settings_customPaperSize', settings.customPaperSize);
    await _prefs.setInt('print_settings_a4Template', settings.a4Template);
    await _prefs.setInt('print_settings_bluetoothTemplate', settings.bluetoothTemplate);
    await _prefs.setInt('print_settings_statementTemplate', settings.statementTemplate);
    
    state = settings;
  }
}
