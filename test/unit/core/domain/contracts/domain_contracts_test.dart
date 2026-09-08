/// اختبارات عقود المجال الموحدة (Task 0.3 — طبقة العمل المشتركة).
///
/// تغطي: [DocumentStatus]، [OperationResult]، [AuditEntry]،
/// [DocumentDraft]، [PostingPreview].
library;

import 'package:basir_accounting_system/core/domain/contracts/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocumentStatus', () {
    test('جميع الحالات الست لها مسمّى عربي دلالي', () {
      final labels =
          DocumentStatus.values.map((status) => status.localizedLabel).toList();
      expect(labels, contains('مسودة'));
      expect(labels, contains('بانتظار الاعتماد'));
      expect(labels, contains('معتمدة'));
      expect(labels, contains('مرحّلة'));
      expect(labels, contains('ملغاة'));
      expect(labels, contains('معكوسة'));
    });

    test('الحالات الست تحمل ألوانًا وأيقونات دلالية', () {
      for (final status in DocumentStatus.values) {
        expect(status.semanticIcon, isNotNull);
      }
      expect(DocumentStatus.posted.semanticColor, isNotNull);
      expect(DocumentStatus.cancelled.semanticColor, isNotNull);
    });

    test('الحالة مسودة ليست ملغاة (تمييز دلالي صريح)', () {
      expect(DocumentStatus.draft, isNot(DocumentStatus.cancelled));
      expect(DocumentStatus.draft, isNot(DocumentStatus.posted));
    });
  });

  group('AuditEntry', () {
    final now = DateTime(2026, 8, 13);

    test('حدث اعتماد يلتقط من نفّذ ومتى ولماذا', () {
      final entry = AuditEntry(
        type: AuditEventType.approved,
        operatorName: 'سارة الأحمدي',
        occurredAt: now,
        reason: 'اعتماد وفق صلاحية المدير المالي',
        referenceId: 'INV-0001',
      );
      expect(entry.operatorName, 'سارة الأحمدي');
      expect(entry.reason, contains('صلاحية المدير المالي'));
      expect(entry.referenceId, 'INV-0001');
    });

    test('أنواع الأحداث الثمانية تحمل تسميات عربية', () {
      final labels =
          AuditEventType.values.map((t) => t.localizedLabel).toList();
      expect(labels, contains('اعتماد'));
      expect(labels, contains('ترحيل'));
      expect(labels, contains('إلغاء'));
      expect(labels, contains('عكس'));
      expect(labels, contains('إرجاع'));
    });

    test('تساوي الأحداث يعتمد الحقول الخمسة', () {
      final a = AuditEntry(
        type: AuditEventType.posted,
        operatorName: 'خالد',
        occurredAt: now,
        reason: 'ترحيل نهائي',
      );
      final b = AuditEntry(
        type: AuditEventType.posted,
        operatorName: 'خالد',
        occurredAt: now,
        reason: 'ترحيل نهائي',
      );
      final c = AuditEntry(
        type: AuditEventType.edited,
        operatorName: 'خالد',
        occurredAt: now,
      );
      expect(a, equals(b));
      expect(a, isNot(c));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('OperationResult', () {
    test('النتيجة الناجحة تحمل القيمة', () {
      const result =
          OperationResult<int>.success(value: 42, message: 'تم الترحيل');
      expect(result.success, isTrue);
      expect(result.value, 42);
      expect(result.hasValue, isTrue);
    });

    test('النتيجة الفاشلة تحمل الرسالة ولا تحمل قيمة', () {
      const result = OperationResult<int>.failure(message: 'رصيد غير كافٍ');
      expect(result.success, isFalse);
      expect(result.value, isNull);
      expect(result.message, 'رصيد غير كافٍ');
    });

    test('getOrThrow يعيد القيمة عند النجاح', () {
      const result = OperationResult<String>.success(value: 'INV-0001');
      expect(result.getOrThrow(), 'INV-0001');
    });

    test('getOrThrow يرمي OperationFailedException عند الفشل', () {
      const result = OperationResult<int>.failure(message: 'فشل الحفظ');
      expect(
        () => result.getOrThrow(),
        throwsA(
          isA<OperationFailedException>()
              .having((e) => e.message, 'message', 'فشل الحفظ'),
        ),
      );
    });

    test('fold يختار المسار الصحيح', () {
      const success = OperationResult<int>.success(value: 7);
      const failure = OperationResult<int>.failure(message: 'خطأ');
      expect(success.fold((v) => 'ok-$v', (m) => 'fail-$m'), 'ok-7');
      expect(failure.fold((v) => 'ok-$v', (m) => 'fail-$m'), 'fail-خطأ');
    });

    test('التساوي يعتمد الحالة والقيمة والرسالة', () {
      const a = OperationResult<int>.success(value: 1);
      const b = OperationResult<int>.success(value: 1);
      const c = OperationResult<int>.success(value: 2);
      expect(a, equals(b));
      expect(a, isNot(c));
    });

    test('سجل التدقيق المرفق قابل للفحص عبر hasAuditTrail', () {
      final entry = AuditEntry(
        type: AuditEventType.posted,
        operatorName: 'نظام',
        occurredAt: DateTime(2026, 8, 13),
        reason: 'ترحيل آلي',
      );
      final withTrail =
          OperationResult<int>.success(value: 1, auditTrail: [entry]);
      const withoutTrail = OperationResult<int>.success(value: 1);
      expect(withTrail.hasAuditTrail, isTrue);
      expect(withoutTrail.hasAuditTrail, isFalse);
    });
  });

  group('DraftLineItem', () {
    test('الحسابات المالية صحيحة: صافي وضريبة وإجمالي', () {
      const line = DraftLineItem(
        id: 'L1',
        description: 'صنف تجريبي',
        quantity: 10,
        unitPrice: 100,
        discount: 50,
      );
      expect(line.netAmount, 950); // 10×100-50
      expect(line.taxAmount, 142.5); // 950×0.15
      expect(line.grossAmount, 1092.5);
    });

    test('تساوي البنود يعتمد الحقول الستة', () {
      const a =
          DraftLineItem(id: 'L1', description: 'س', quantity: 1, unitPrice: 1);
      const b =
          DraftLineItem(id: 'L1', description: 'س', quantity: 1, unitPrice: 1);
      const c =
          DraftLineItem(id: 'L1', description: 'س', quantity: 2, unitPrice: 1);
      expect(a, equals(b));
      expect(a, isNot(c));
    });
  });

  group('DocumentDraft', () {
    final empty = DocumentDraft(
      id: 'D1',
      documentType: 'invoice',
      currencyCode: 'SAR',
    );

    test('حالة المسودة دائمًا draft', () {
      expect(empty.status, DocumentStatus.draft);
    });

    test('المجموع الكلي يشمل صافي البنود والضريبة', () {
      final draft = DocumentDraft(
        id: 'D1',
        documentType: 'invoice',
        currencyCode: 'SAR',
        lines: const [
          DraftLineItem(
            id: 'L1',
            description: 'أ',
            quantity: 2,
            unitPrice: 100,
          ),
          DraftLineItem(
            id: 'L2',
            description: 'ب',
            quantity: 1,
            unitPrice: 50,
            discount: 10,
          ),
        ],
      );
      expect(draft.subTotal, 200 + 40); // 200 + (50-10)
      expect(draft.taxTotal, (200 + 40) * 0.15);
      expect(draft.grandTotal, 240 * 1.15);
    });

    test('isSaveable يتطلب بنودًا صالحة وإجماليًا موجبًا', () {
      expect(empty.isSaveable, isFalse);
      final valid = DocumentDraft(
        id: 'D1',
        documentType: 'invoice',
        currencyCode: 'SAR',
        lines: const [
          DraftLineItem(id: 'L1', description: 'أ', quantity: 1, unitPrice: 10),
        ],
      );
      expect(valid.isSaveable, isTrue);

      final zeroQuantity = DocumentDraft(
        id: 'D1',
        documentType: 'invoice',
        currencyCode: 'SAR',
        lines: const [
          DraftLineItem(id: 'L1', description: 'أ', quantity: 0, unitPrice: 10),
        ],
      );
      expect(zeroQuantity.isSaveable, isFalse);
    });

    test('copyWithLines تنشئ نسخة جديدة ببنود محدثة', () {
      final updated = empty.copyWithLines([
        const DraftLineItem(
          id: 'L1',
          description: 'بند جديد',
          quantity: 3,
          unitPrice: 20,
        ),
      ]);
      expect(updated.lines, hasLength(1));
      expect(updated.grandTotal, greaterThan(0));
    });

    test('updatedAt يُسجَّل عند الإنشاء ويُحدَّث مع النسخ', () {
      final draft = empty.copyWithLines(const [
        DraftLineItem(id: 'L1', description: 'أ', quantity: 1, unitPrice: 10),
      ]);
      expect(draft.updatedAt, isNotNull);
    });
  });

  group('PostingPreview', () {
    const preview = PostingPreview(
      documentId: 'INV-0001',
      lines: [
        PostingImpactLine(
          kind: PostingImpactKind.ledgerEntry,
          direction: PostingDirection.debit,
          description: 'ذمم العملاء',
          amount: 1150,
        ),
        PostingImpactLine(
          kind: PostingImpactKind.taxLiability,
          direction: PostingDirection.credit,
          description: 'الضريبة المستحقة',
          amount: 150,
        ),
        PostingImpactLine(
          kind: PostingImpactKind.ledgerEntry,
          direction: PostingDirection.reversal,
          description: 'أثر عكسي معلن',
          amount: 200,
        ),
      ],
      requiresAdditionalApproval: true,
      approvalReason: 'مبلغ يتجاوز حد الاعتماد المباشر',
    );

    test('المجاميع تحسب المدين والعكسي منفصلين', () {
      expect(preview.totalDebit, 1150 + 150);
      expect(preview.totalReversal, 200);
    });

    test('الترحيل الفوري يعني غياب الجدولة', () {
      expect(preview.isImmediate, isTrue);
    });

    test('buildApprovalEvent ينشئ حدث اعتمادًا مرتبطًا بالوثيقة', () {
      final event = preview.buildApprovalEvent(
        approverName: 'سارة الأحمدي',
        reason: 'اعتماد بعد المراجعة',
      );
      expect(event.type, AuditEventType.approved);
      expect(event.operatorName, 'سارة الأحمدي');
      expect(event.referenceId, 'INV-0001');
    });

    test('المعاينة المجدولة ليست فورية', () {
      final scheduled = PostingPreview(
        documentId: 'INV-0002',
        lines: const [],
        scheduledAt: DateTime(2026, 8, 15),
      );
      expect(scheduled.isImmediate, isFalse);
    });
  });
}
