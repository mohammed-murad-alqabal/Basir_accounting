# AI/ML Design: Baseer Intelligent Financial System

**Document ID:** BASEER-P4-005  
**Version:** 1.0  
**Date:** December 27, 2025  
**Status:** ✅ Approved  
**Classification:** Technical Architecture - AI/ML

---

## 1. AI/ML Overview

### Vision

Transform Baseer from a passive tool to an intelligent financial assistant through AI-powered automation, insights, and predictions.

### AI Engine Name: **Baseera** (بصيرة)

---

## 2. AI Features Roadmap

| Feature              | Phase  | Priority | Complexity |
| -------------------- | ------ | -------- | ---------- |
| Auto-Categorization  | MVP    | P0       | Medium     |
| Receipt OCR          | MVP    | P0       | Medium     |
| Spending Insights    | Growth | P1       | Medium     |
| Cash Flow Prediction | Growth | P2       | High       |
| Anomaly Detection    | Scale  | P2       | High       |
| NLP Query Interface  | Scale  | P3       | Very High  |

---

## 3. Auto-Categorization

### Approach

Hybrid model combining rule-based matching and ML classification.

### Architecture

```
┌─────────────┐     ┌───────────────┐     ┌─────────────────┐
│ Transaction │────▶│ Pre-process   │────▶│ Rule Matcher    │
│   Input     │     │ (Normalize)   │     │ (Exact matches) │
└─────────────┘     └───────────────┘     └────────┬────────┘
                                                   │
                            ┌──────────────────────┴──────┐
                            │ Match?                       │
                            │  Yes ──▶ Return Category    │
                            │  No  ──▶ ML Classification  │
                            └─────────────────────────────┘
                                          │
                    ┌─────────────────────┴─────────────────────┐
                    ▼                                           ▼
            ┌─────────────────┐                     ┌───────────────────┐
            │ TFLite Model    │                     │ Confidence Check  │
            │ (On-Device)     │                     │  >0.8 ──▶ Accept  │
            └─────────────────┘                     │  <0.8 ──▶ Suggest │
                                                    └───────────────────┘
```

### Model Specifications

| Attribute       | Value                        |
| --------------- | ---------------------------- |
| Model Type      | Multi-class Classifier       |
| Architecture    | Neural Network (3-layer MLP) |
| Input           | Text embeddings (128 dim)    |
| Output          | 20 categories + confidence   |
| Training Data   | 100K+ labeled transactions   |
| Accuracy Target | >90% on common categories    |
| Inference Time  | <50ms on-device              |

### Categories

| ID  | Arabic        | English           |
| --- | ------------- | ----------------- |
| 1   | مطاعم وطعام   | Food & Dining     |
| 2   | نقل ومواصلات  | Transportation    |
| 3   | تسوق          | Shopping          |
| 4   | فواتير وخدمات | Bills & Utilities |
| 5   | صحة وطبي      | Healthcare        |
| 6   | ترفيه         | Entertainment     |
| 7   | سفر           | Travel            |
| 8   | تعليم         | Education         |
| 9   | اشتراكات      | Subscriptions     |
| 10  | أخرى          | Other             |

### User Feedback Loop

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ AI Suggests │────▶│ User Edits  │────▶│ Store       │
│  Category   │     │ (Optional)  │     │ Correction  │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                                    ┌──────────▼──────────┐
                                    │ Retrain Model       │
                                    │ (Weekly batch)      │
                                    └─────────────────────┘
```

---

## 4. Receipt OCR

### Technology Stack

| Component       | Technology    | Rationale         |
| --------------- | ------------- | ----------------- |
| Image Capture   | Camera API    | Native quality    |
| Pre-processing  | OpenCV        | Deskew, enhance   |
| OCR Engine      | Google ML Kit | Arabic support    |
| Post-processing | Custom NLP    | Entity extraction |

### Entity Extraction

| Entity        | Extraction Method                |
| ------------- | -------------------------------- |
| Merchant Name | Top text, logo detection         |
| Total Amount  | Pattern matching (إجمالي, Total) |
| Date          | Date format regex                |
| Tax Amount    | VAT pattern matching             |
| Items         | Line-by-line parsing             |

### Arabic OCR Challenges

| Challenge            | Solution                    |
| -------------------- | --------------------------- |
| RTL text direction   | Pre-process orientation     |
| Connected letters    | ML Kit Arabic model         |
| Mixed Arabic/English | Language detection per line |
| Handwritten text     | Optional, best effort       |
| Poor image quality   | Enhancement pipeline        |

---

## 5. Spending Insights

### Insight Types

| Insight                 | Trigger                    | Example                                               |
| ----------------------- | -------------------------- | ----------------------------------------------------- |
| **Unusual Spending**    | >50% above average         | "إنفاقك على المطاعم هذا الشهر أعلى من المعتاد بـ 60%" |
| **Recurring Detection** | Same merchant, same amount | "اكتشفنا اشتراك شهري في Netflix"                      |
| **Budget Warning**      | 80% of budget consumed     | "استهلكت 80% من ميزانية التسوق"                       |
| **Saving Opportunity**  | Pattern analysis           | "يمكنك توفير 200 ريال شهريًا بتقليل الطلب الخارجي"    |

### Insight Generation Pipeline

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ Transaction │────▶│ Aggregate   │────▶│ Rule Engine │
│   History   │     │ (Weekly)    │     │             │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                    ┌──────────────────────────┴─────┐
                    ▼                                ▼
            ┌─────────────────┐          ┌───────────────────┐
            │ Generate Text   │          │ Priority Score    │
            │ (Arabic NLG)    │          │                   │
            └─────────────────┘          └───────────────────┘
                    │                              │
                    └──────────────┬───────────────┘
                                   ▼
                         ┌─────────────────┐
                         │ Push to User    │
                         │ (Max 3/week)    │
                         └─────────────────┘
```

---

## 6. Cash Flow Prediction (Future)

### Model Architecture

| Component       | Approach                           |
| --------------- | ---------------------------------- |
| Model Type      | LSTM / Transformer                 |
| Input           | 90 days transaction history        |
| Output          | 30-day cash flow forecast          |
| Features        | Amount, category, date, recurrence |
| Accuracy Target | ±15% on 7-day forecast             |

---

## 7. Privacy & Ethics

### Data Principles

| Principle                  | Implementation                |
| -------------------------- | ----------------------------- |
| **On-Device First**        | ML models run locally         |
| **Data Minimization**      | Only necessary data processed |
| **User Control**           | AI features can be disabled   |
| **Transparency**           | "Why this?" explanations      |
| **No Third-Party Sharing** | AI data never leaves Baseer   |

### Server-Side AI

When server processing is needed:

- Data anonymized before sending
- No raw transaction text to LLMs
- Aggregated patterns only
- Clear user consent

---

## 8. Model Management

### MLOps Pipeline

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Training   │────▶│ Validation  │────▶│  Convert    │
│  (Cloud)    │     │ (Test set)  │     │ (TFLite)    │
└─────────────┘     └─────────────┘     └──────┬──────┘
                                               │
                    ┌──────────────────────────┴─────┐
                    ▼                                ▼
            ┌─────────────────┐          ┌───────────────────┐
            │ A/B Test        │          │ App Update        │
            │ (5% users)      │          │ (Bundled model)   │
            └─────────────────┘          └───────────────────┘
```

### Model Versioning

| Version | Date   | Changes                      |
| ------- | ------ | ---------------------------- |
| v1.0    | Launch | Initial 20 categories        |
| v1.1    | +3 mo  | Arabic merchant improvements |
| v2.0    | +6 mo  | User feedback incorporated   |

---

**Document Control:**

- Prepared by: Baseer Development Agent Team
- Date: December 27, 2025
