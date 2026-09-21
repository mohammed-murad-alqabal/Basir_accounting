class PrintSettings {
  const PrintSettings({
    this.paperSize = '80mm',
    this.template = 'A4',
    this.fontSize = 20,
    this.paddingBottom = 7,
    this.printCopies = 1,
    this.showUnit = false,
    this.printTwoCopies = false,
    this.fontType = '1',
    this.customPaperSize = 375,
    this.a4Template = 0,
    this.bluetoothTemplate = 0,
    this.statementTemplate = 0,
  });
  final String paperSize;
  final String template;
  final double fontSize;
  final int paddingBottom;
  final int printCopies;
  final bool showUnit;
  final bool printTwoCopies;
  final String fontType;

  final int customPaperSize;

  // New fields for Task 3
  final int a4Template;
  final int bluetoothTemplate;
  final int statementTemplate;

  PrintSettings copyWith({
    String? paperSize,
    String? template,
    double? fontSize,
    int? paddingBottom,
    int? printCopies,
    bool? showUnit,
    bool? printTwoCopies,
    String? fontType,
    int? customPaperSize,
    int? a4Template,
    int? bluetoothTemplate,
    int? statementTemplate,
  }) => PrintSettings(
    paperSize: paperSize ?? this.paperSize,
    template: template ?? this.template,
    fontSize: fontSize ?? this.fontSize,
    paddingBottom: paddingBottom ?? this.paddingBottom,
    printCopies: printCopies ?? this.printCopies,
    showUnit: showUnit ?? this.showUnit,
    printTwoCopies: printTwoCopies ?? this.printTwoCopies,
    fontType: fontType ?? this.fontType,
    customPaperSize: customPaperSize ?? this.customPaperSize,
    a4Template: a4Template ?? this.a4Template,
    bluetoothTemplate: bluetoothTemplate ?? this.bluetoothTemplate,
    statementTemplate: statementTemplate ?? this.statementTemplate,
  );
}
