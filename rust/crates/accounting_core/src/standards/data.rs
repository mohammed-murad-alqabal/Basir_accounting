//! IFRS Standards Data
//!
//! Contains the authoritative content for IFRS standards.
//! This data is loaded into the Standards Registry for validation and reference.
//!
//! # Task 2.1: IFRS Conceptual Framework 2018
//! # Task 2.2: Core IFRS Standards (IAS 1, IAS 8, IAS 10, IFRS 15)

use super::models::{StandardBody, StandardEntry, StandardReference};
use chrono::NaiveDate;

/// Load IFRS Conceptual Framework 2018 standards.
///
/// Covers Chapters 1-8 with key paragraph references:
/// - Chapter 1: Objective of financial reporting
/// - Chapter 2: Qualitative characteristics
/// - Chapter 3: Financial statements and reporting entity
/// - Chapter 4: Elements of financial statements (definitions)
/// - Chapter 5: Recognition and derecognition
/// - Chapter 6: Measurement
/// - Chapter 7: Presentation and disclosure
/// - Chapter 8: Concepts of capital and capital maintenance
pub fn load_conceptual_framework() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2018, 3, 29).unwrap();

    vec![
        // Chapter 1: Objective of General Purpose Financial Reporting
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "1.2"),
            title: "Objective of Financial Reporting".to_string(),
            full_text: "The objective of general purpose financial reporting is to provide \
                       financial information about the reporting entity that is useful to \
                       existing and potential investors, lenders and other creditors in \
                       making decisions relating to providing resources to the entity."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        // Chapter 2: Qualitative Characteristics
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "2.4"),
            title: "Relevance".to_string(),
            full_text: "Relevant financial information is capable of making a difference in \
                       the decisions made by users. Information may be capable of making a \
                       difference in a decision even if some users choose not to take \
                       advantage of it or are already aware of it from other sources."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "2.12"),
            title: "Faithful Representation".to_string(),
            full_text: "To be a perfectly faithful representation, a depiction would have \
                       three characteristics. It would be complete, neutral and free from error."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "2.29"),
            title: "Comparability".to_string(),
            full_text: "Comparability is the qualitative characteristic that enables users \
                       to identify and understand similarities in, and differences among, items."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "2.31"),
            title: "Verifiability".to_string(),
            full_text: "Verifiability helps assure users that information faithfully represents \
                       the economic phenomena it purports to represent."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "2.33"),
            title: "Timeliness".to_string(),
            full_text: "Timeliness means having information available to decision-makers in time \
                       to be capable of influencing their decisions."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "2.34"),
            title: "Understandability".to_string(),
            full_text: "Classifying, characterising and presenting information clearly and \
                       concisely makes it understandable."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        // Chapter 4: Elements of Financial Statements
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "4.3"),
            title: "Definition of an Asset".to_string(),
            full_text: "An asset is a present economic resource controlled by the entity \
                       as a result of past events. An economic resource is a right that \
                       has the potential to produce economic benefits."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "4.4"),
            title: "Economic Resource".to_string(),
            full_text: "An economic resource is a right that has the potential to produce \
                       economic benefits."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "4.26"),
            title: "Definition of a Liability".to_string(),
            full_text: "A liability is a present obligation of the entity to transfer an \
                       economic resource as a result of past events."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "4.63"),
            title: "Definition of Equity".to_string(),
            full_text: "Equity is the residual interest in the assets of the entity after \
                       deducting all its liabilities."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "4.68"),
            title: "Definition of Income".to_string(),
            full_text: "Income is increases in assets, or decreases in liabilities, that \
                       result in increases in equity, other than those relating to \
                       contributions from holders of equity claims."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "4.69"),
            title: "Definition of Expenses".to_string(),
            full_text: "Expenses are decreases in assets, or increases in liabilities, that \
                       result in decreases in equity, other than those relating to \
                       distributions to holders of equity claims."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        // Chapter 5: Recognition and Derecognition
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "5.1"),
            title: "Recognition Process".to_string(),
            full_text: "Recognition is the process of capturing for inclusion in the statement \
                       of financial position or the statement(s) of financial performance an \
                       item that meets the definition of one of the elements of financial \
                       statements—an asset, a liability, equity, income or expenses."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "5.7"),
            title: "Recognition Criteria".to_string(),
            full_text: "An asset or liability is recognised only if recognition of that asset \
                       or liability and of any resulting income, expenses or changes in \
                       equity provides users of financial statements with information that \
                       is useful, ie with: (a) relevant information about the asset or \
                       liability and about any resulting income, expenses or changes in equity; \
                       and (b) a faithful representation of the asset or liability and of any \
                       resulting income, expenses or changes in equity."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "5.25"),
            title: "Derecognition".to_string(),
            full_text: "Derecognition is the removal of all or part of a recognised asset or \
                       liability from an entity's statement of financial position."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        // Chapter 6: Measurement
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "6.1"),
            title: "Measurement Process".to_string(),
            full_text: "Measurement is the process of quantifying, in monetary terms, information \
                       about an entity's assets, liabilities, equity, income and expenses."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "6.4"),
            title: "Historical Cost".to_string(),
            full_text: "Historical cost measures provide monetary information about assets, \
                       liabilities and related income and expenses using information derived, \
                       at least in part, from the price of the transaction or other event \
                       that gave rise to them."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "6.10"),
            title: "Current Value - Fair Value".to_string(),
            full_text: "Fair value is the price that would be received to sell an asset, or \
                       paid to transfer a liability, in an orderly transaction between market \
                       participants at the measurement date."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "6.17"),
            title: "Value in Use".to_string(),
            full_text: "Value in use is the present value of the cash flows, or other economic \
                       benefits, that an entity expects to derive from the use of an asset and \
                       from its ultimate disposal."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "6.22"),
            title: "Current Cost".to_string(),
            full_text: "The current cost of an asset is the cost of an equivalent asset at the \
                       measurement date, comprising the consideration that would be paid at the \
                       measurement date plus the transaction costs that would be incurred at \
                       that date."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        // Chapter 3: Financial Statements and the Reporting Entity
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "3.2"),
            title: "Objective and Scope of Financial Statements".to_string(),
            full_text: "The objective of financial statements is to provide financial information \
                       about the reporting entity's assets, liabilities, equity, income and expenses \
                       that is useful to users of financial statements in assessing the prospects \
                       for future net cash inflows to the reporting entity and in assessing \
                       management's stewardship of the entity's economic resources."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "3.10"),
            title: "Reporting Entity".to_string(),
            full_text: "A reporting entity is an entity that is required, or chooses, to \
                       prepare financial statements. A reporting entity can be a single \
                       entity or a portion of an entity or can comprise more than one entity."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        // Chapter 7: Presentation and Disclosure
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "7.1"),
            title: "Effective Communication".to_string(),
            full_text: "A reporting entity communicates information about its assets, \
                       liabilities, equity, income and expenses by presenting and \
                       disclosing information in its financial statements."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        // Chapter 8: Concepts of Capital and Capital Maintenance
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "CF", "8.1"),
            title: "Concepts of Capital".to_string(),
            full_text: "A financial concept of capital is adopted by most entities in \
                       preparing their financial statements. Under a financial concept of \
                       capital, such as invested money or invested purchasing power, \
                       capital is synonymous with the net assets or equity of the entity."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load IAS 1 - Presentation of Financial Statements
pub fn load_ias_1() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2007, 9, 6).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "1"),
            title: "Objective of IAS 1".to_string(),
            full_text: "This Standard prescribes the basis for presentation of general purpose \
                       financial statements to ensure comparability both with the entity's \
                       financial statements of previous periods and with the financial \
                       statements of other entities.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "9"),
            title: "Fair Presentation and Compliance".to_string(),
            full_text: "Financial statements shall present fairly the financial position, \
                       financial performance and cash flows of an entity.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "10"),
            title: "Complete Set of Financial Statements".to_string(),
            full_text: "A complete set of financial statements comprises: (a) a statement of \
                       financial position; (b) a statement of profit or loss and other \
                       comprehensive income; (c) a statement of changes in equity; (d) a \
                       statement of cash flows; (e) notes.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "25"),
            title: "Going Concern".to_string(),
            full_text: "When preparing financial statements, management shall make an assessment \
                       of an entity's ability to continue as a going concern.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "27"),
            title: "Accrual Basis of Accounting".to_string(),
            full_text: "An entity shall prepare its financial statements, except for cash flow \
                       information, using the accrual basis of accounting.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "29"),
            title: "Materiality and Aggregation".to_string(),
            full_text: "An entity shall present separately each material class of similar items. \
                       An entity shall present separately items of a dissimilar nature or \
                       function unless they are immaterial.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "32"),
            title: "Offsetting".to_string(),
            full_text: "An entity shall not offset assets and liabilities or income and expenses, \
                       unless required or permitted by an IFRS.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "54"),
            title: "Minimum Line Items - Financial Position".to_string(),
            full_text: "The statement of financial position shall include line items that present: \
                       (a) property, plant and equipment; (b) investment property; (c) intangible \
                       assets; (d) financial assets; (e) investments accounted for using the equity \
                       method; (f) biological assets; (g) inventories; (h) trade and other receivables; \
                       (i) cash and cash equivalents; and more.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "60"),
            title: "Current/Non-Current Distinction".to_string(),
            full_text: "An entity shall present current and non-current assets, and current and \
                       non-current liabilities, as separate classifications in its statement of \
                       financial position.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "82"),
            title: "Information in Profit or Loss".to_string(),
            full_text: "In addition to items required by other IFRSs, the statement of profit or \
                       loss shall include line items that present: (a) revenue; (b) gains and \
                       losses arising from the derecognition of financial assets; (c) finance \
                       costs; (d) share of the profit or loss of associates and joint ventures; \
                       (e) tax expense; (f) any other items.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "1", "117"),
            title: "Disclosure of Accounting Policies".to_string(),
            full_text: "An entity shall disclose its material accounting policies comprising: \
                       (a) the measurement basis (or bases) used in preparing the financial \
                       statements; and (b) the other accounting policies used that are relevant \
                       to an understanding of the financial statements.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load IAS 8 - Accounting Policies, Changes in Estimates and Errors
pub fn load_ias_8() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2005, 1, 1).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "8", "5"),
            title: "Definition of Accounting Policies".to_string(),
            full_text: "Accounting policies are the specific principles, bases, conventions, \
                       rules and practices applied by an entity in preparing and presenting \
                       financial statements."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "8", "7"),
            title: "Selection of Accounting Policies".to_string(),
            full_text: "When an IFRS specifically applies to a transaction, other event or \
                       condition, the accounting policy or policies applied to that item shall \
                       be determined by applying that IFRS."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "8", "13"),
            title: "Consistency of Accounting Policies".to_string(),
            full_text: "An entity shall select and apply its accounting policies consistently \
                       for similar transactions, other events and conditions."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "8", "14"),
            title: "Changes in Accounting Policies".to_string(),
            full_text: "An entity shall change an accounting policy only if the change: \
                       (a) is required by an IFRS; or (b) results in the financial statements \
                       providing reliable and more relevant information."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "8", "32"),
            title: "Definition of Accounting Estimate".to_string(),
            full_text: "Accounting estimates are monetary amounts in financial statements that \
                       are subject to measurement uncertainty."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "8", "41"),
            title: "Prior Period Errors".to_string(),
            full_text: "Prior period errors are omissions from, and misstatements in, the \
                       entity's financial statements for one or more prior periods arising \
                       from a failure to use, or misuse of, reliable information."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "8", "42"),
            title: "Retrospective Restatement".to_string(),
            full_text: "An entity shall correct material prior period errors retrospectively \
                       in the first set of financial statements approved for issue after \
                       their discovery."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load IAS 10 - Events After the Reporting Period
pub fn load_ias_10() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2005, 1, 1).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "10", "3"),
            title: "Definition of Events After Reporting Period".to_string(),
            full_text: "Events after the reporting period are those events, favourable and \
                       unfavourable, that occur between the end of the reporting period and \
                       the date when the financial statements are authorised for issue."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "10", "8"),
            title: "Adjusting Events".to_string(),
            full_text: "An entity shall adjust the amounts recognised in its financial statements \
                       to reflect adjusting events after the reporting period."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "10", "10"),
            title: "Non-Adjusting Events".to_string(),
            full_text:
                "An entity shall not adjust the amounts recognised in its financial statements \
                       to reflect non-adjusting events after the reporting period."
                    .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "10", "14"),
            title: "Going Concern After Reporting Period".to_string(),
            full_text: "An entity shall not prepare its financial statements on a going concern \
                       basis if management determines after the reporting period either that it \
                       intends to liquidate the entity or to cease trading, or that it has no \
                       realistic alternative but to do so."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load IFRS 15 - Revenue from Contracts with Customers
pub fn load_ifrs_15() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2018, 1, 1).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "15", "1"),
            title: "Objective of IFRS 15".to_string(),
            full_text: "The objective of this Standard is to establish the principles that an \
                       entity shall apply to report useful information to users of financial \
                       statements about the nature, amount, timing and uncertainty of revenue \
                       and cash flows arising from a contract with a customer.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "15", "9"),
            title: "Step 1: Identify the Contract".to_string(),
            full_text: "An entity shall account for a contract with a customer that is within \
                       the scope of this Standard only when all of the following criteria are \
                       met: (a) the parties to the contract have approved the contract; \
                       (b) the entity can identify each party's rights; (c) the entity can \
                       identify the payment terms; (d) the contract has commercial substance; \
                       (e) it is probable that the entity will collect the consideration.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "15", "22"),
            title: "Step 2: Identify Performance Obligations".to_string(),
            full_text: "At contract inception, an entity shall assess the goods or services \
                       promised in a contract with a customer and shall identify as a \
                       performance obligation each promise to transfer to the customer either: \
                       (a) a good or service (or a bundle of goods or services) that is distinct; \
                       or (b) a series of distinct goods or services that are substantially the same.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "15", "31"),
            title: "Step 3: Determine the Transaction Price".to_string(),
            full_text: "An entity shall consider the terms of the contract and its customary \
                       business practices to determine the transaction price. The transaction \
                       price is the amount of consideration to which an entity expects to be \
                       entitled in exchange for transferring promised goods or services.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "15", "35"),
            title: "Satisfaction of Performance Obligations".to_string(),
            full_text: "An entity shall recognise revenue when (or as) the entity satisfies a \
                       performance obligation by transferring a promised good or service \
                       (ie an asset) to a customer. An asset is transferred when (or as) the \
                       customer obtains control of that asset.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "15", "38"),
            title: "Performance Obligations Satisfied Over Time".to_string(),
            full_text: "An entity transfers control of a good or service over time and, therefore, \
                       satisfies a performance obligation and recognises revenue over time if one of \
                       the following criteria is met: (a) the customer simultaneously receives and \
                       consumes the benefits; (b) the entity's performance creates or enhances an \
                       asset that the customer controls; (c) the entity's performance does not \
                       create an asset with an alternative use.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "15", "73"),
            title: "Step 4: Allocate the Transaction Price".to_string(),
            full_text: "The objective when allocating the transaction price is for an entity to \
                       allocate the transaction price to each performance obligation (or distinct \
                       good or service) in an amount that depicts the amount of consideration to \
                       which the entity expects to be entitled in exchange for transferring the \
                       promised goods or services to the customer.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load ISA 500 - Audit Evidence
///
/// Task 2.3: Load Audit/Control Standards References
pub fn load_isa_500() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2009, 12, 15).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::ISA, "500", "4"),
            title: "Objective of Audit Evidence".to_string(),
            full_text: "The objective of the auditor is to design and perform audit procedures \
                       in such a way as to enable the auditor to obtain sufficient appropriate \
                       audit evidence to be able to draw reasonable conclusions on which to \
                       base the auditor's opinion."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::ISA, "500", "5"),
            title: "Definition of Audit Evidence".to_string(),
            full_text: "Audit evidence is information used by the auditor in arriving at the \
                       conclusions on which the auditor's opinion is based. Audit evidence \
                       includes both information contained in the accounting records underlying \
                       the financial statements and other information."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::ISA, "500", "6"),
            title: "Sufficient Appropriate Audit Evidence".to_string(),
            full_text: "Sufficiency is the measure of the quantity of audit evidence. \
                       Appropriateness is the measure of the quality of audit evidence; \
                       that is, its relevance and its reliability in providing support for \
                       the conclusions on which the auditor's opinion is based."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::ISA, "500", "7"),
            title: "Reliability of Audit Evidence".to_string(),
            full_text: "The reliability of information to be used as audit evidence is influenced \
                       by its source and its nature, and the circumstances under which it is \
                       obtained, including the controls over its preparation and maintenance."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load SOX 404 - Internal Control Assessment
///
/// Task 2.3: Load Audit/Control Standards References
pub fn load_sox_404() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2002, 7, 30).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::SOX, "404", "a"),
            title: "Management Assessment of Internal Controls".to_string(),
            full_text: "The Commission shall prescribe rules requiring each annual report to \
                       contain an internal control report, which shall: (1) state the \
                       responsibility of management for establishing and maintaining an \
                       adequate internal control structure and procedures for financial reporting; \
                       and (2) contain an assessment of the effectiveness of the internal control \
                       structure and procedures."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::SOX, "404", "b"),
            title: "Attestation by External Auditor".to_string(),
            full_text: "Each registered public accounting firm that prepares or issues the audit \
                       report for the issuer shall attest to, and report on, the assessment made \
                       by the management of the issuer."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::SOX, "302", "1"),
            title: "CEO/CFO Certification".to_string(),
            full_text: "The principal executive officer and principal financial officer certify \
                       that the signing officer has reviewed the report; the report does not \
                       contain any untrue statement of a material fact; and the financial \
                       statements fairly present in all material respects the financial condition."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load COSO Internal Control Framework
///
/// Task 2.3: Load Audit/Control Standards References
pub fn load_coso_framework() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2013, 5, 14).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::COSO, "IC", "1"),
            title: "Control Environment".to_string(),
            full_text:
                "The control environment is the set of standards, processes, and structures \
                       that provide the basis for carrying out internal control across the \
                       organization. The board of directors and senior management establish \
                       the tone at the top regarding the importance of internal control."
                    .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::COSO, "IC", "2"),
            title: "Risk Assessment".to_string(),
            full_text: "Risk assessment involves a dynamic and iterative process for identifying \
                       and assessing risks to the achievement of objectives. Risks to the \
                       achievement of these objectives are considered relative to established \
                       risk tolerances."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::COSO, "IC", "3"),
            title: "Control Activities".to_string(),
            full_text: "Control activities are the actions established through policies and \
                       procedures that help ensure that management's directives to mitigate \
                       risks to the achievement of objectives are carried out."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::COSO, "IC", "4"),
            title: "Information and Communication".to_string(),
            full_text: "Information is necessary for the entity to carry out internal control \
                       responsibilities. Management obtains or generates and uses relevant and \
                       quality information from both internal and external sources to support \
                       the functioning of internal control."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::COSO, "IC", "5"),
            title: "Monitoring Activities".to_string(),
            full_text: "Ongoing evaluations, separate evaluations, or some combination of the two \
                       are used to ascertain whether each of the five components of internal \
                       control is present and functioning."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load IFRS 18 - Presentation and Disclosure in Financial Statements
pub fn load_ifrs_18() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2024, 4, 9).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "18", "1"),
            title: "Objective of IFRS 18".to_string(),
            full_text: "The objective of this Standard is to set out requirements for the \
                       presentation and disclosure of information in financial statements \
                       to help users of financial statements make better decisions."
                .to_string(),
            effective_date,
            supersedes: vec![], // Supersedes components of IAS 1
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "18", "25"),
            title: "Operating Category".to_string(),
            full_text: "The operating category comprises all income and expenses that are not \
                       classified in the other categories (investing, financing, income taxes \
                       and discontinued operations)."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "18", "27"),
            title: "Investing Category".to_string(),
            full_text: "The investing category comprises income and expenses from assets \
                       that generate a return individually and largely independently of other \
                       resources held by the entity."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "18", "29"),
            title: "Financing Category".to_string(),
            full_text: "The financing category comprises income and expenses from liabilities \
                       that arise from transactions that involve only the raising of finance."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "18", "33"),
            title: "Operating Profit Subtotal".to_string(),
            full_text: "An entity shall present an operating profit subtotal in the statement \
                       of profit or loss. Operating profit is the subtotal of all income and \
                       expenses classified in the operating category."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IFRS, "18", "105"),
            title: "Management Performance Measures".to_string(),
            full_text: "Management performance measures are subtotals of income and expenses \
                       that: (a) are used in public communications outside financial statements; \
                       (b) complement totals or subtotals specified by IFRS Accounting Standards; \
                       and (c) communicate management's view of an aspect of the financial \
                       performance of the entity as a whole."
                .to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}

/// Load all standards for MVP Phase 1.
///
/// Returns a complete set of standards entries covering:
/// - IFRS Conceptual Framework 2018 (Task 2.1)
/// - IAS 1: Presentation (Task 2.2)
/// - IAS 8: Accounting Policies (Task 2.2)
/// - IAS 10: Events After Reporting Period (Task 2.2)
/// - IFRS 15: Revenue Recognition (Task 2.2)
/// - IFRS 18: Presentation and Disclosure (Added Phase 6)
/// - ISA 500: Audit Evidence (Task 2.3)
/// - SOX 404: Internal Controls (Task 2.3)
/// - COSO: Internal Control Framework (Task 2.3)
pub fn load_all_standards() -> Vec<StandardEntry> {
    let mut all = Vec::new();
    all.extend(load_conceptual_framework());
    all.extend(load_ias_1());
    all.extend(load_ias_8());
    all.extend(load_ias_10());
    all.extend(load_ifrs_15());
    all.extend(load_ias_21());
    all
}

/// Load IAS 21: The Effects of Changes in Foreign Exchange Rates.
pub fn load_ias_21() -> Vec<StandardEntry> {
    let effective_date = NaiveDate::from_ymd_opt(2005, 1, 1).unwrap();

    vec![
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "21", "21"),
            title: "Initial Recognition".to_string(),
            full_text: "A foreign currency transaction shall be recorded, on initial recognition \
                       in the functional currency, by applying to the foreign currency amount \
                       the spot exchange rate between the functional currency and the foreign \
                       currency at the date of the transaction.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "21", "23"),
            title: "Reporting at End of Subsequent Periods".to_string(),
            full_text: "At the end of each reporting period: (a) foreign currency monetary items \
                       shall be translated using the closing rate; (b) non-monetary items that \
                       are measured in terms of historical cost in a foreign currency shall be \
                       translated using the exchange rate at the date of the transaction; and \
                       (c) non-monetary items that are measured at fair value in a foreign \
                       currency shall be translated using the exchange rates at the date when \
                       the fair value was measured.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
        StandardEntry {
            reference: StandardReference::new(StandardBody::IAS, "21", "28"),
            title: "Recognition of Exchange Differences".to_string(),
            full_text: "Exchange differences arising on the settlement of monetary items or on \
                       translating monetary items at rates different from those at which they \
                       were translated on initial recognition during the period or in previous \
                       financial statements shall be recognised in profit or loss in the period \
                       in which they arise.".to_string(),
            effective_date,
            supersedes: vec![],
            superseded_by: None,
        },
    ]
}xtend(load_ifrs_18());
    all.extend(load_isa_500());
    all.extend(load_sox_404());
    all.extend(load_coso_framework());
    all
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_conceptual_framework_coverage() {
        let cf = load_conceptual_framework();
        // Verify we have key paragraphs
        assert!(
            cf.iter().any(|e| e.reference.paragraph == "4.3"),
            "Should have Asset definition"
        );
        assert!(
            cf.iter().any(|e| e.reference.paragraph == "4.26"),
            "Should have Liability definition"
        );
        assert!(
            cf.iter().any(|e| e.reference.paragraph == "4.63"),
            "Should have Equity definition"
        );
        assert!(
            cf.iter().any(|e| e.reference.paragraph == "4.68"),
            "Should have Income definition"
        );
        assert!(
            cf.iter().any(|e| e.reference.paragraph == "4.69"),
            "Should have Expense definition"
        );
        assert!(
            cf.iter().any(|e| e.reference.paragraph == "5.1"),
            "Should have Recognition"
        );
        assert!(
            cf.iter().any(|e| e.reference.paragraph == "6.1"),
            "Should have Measurement"
        );
    }

    #[test]
    fn test_ias_1_coverage() {
        let ias1 = load_ias_1();
        assert!(
            ias1.iter().any(|e| e.reference.paragraph == "10"),
            "Should have Complete Set definition"
        );
        assert!(
            ias1.iter().any(|e| e.reference.paragraph == "54"),
            "Should have Line Items"
        );
        assert!(
            ias1.iter().any(|e| e.reference.paragraph == "60"),
            "Should have Current/Non-Current"
        );
    }

    #[test]
    fn test_ifrs_15_five_step_model() {
        let ifrs15 = load_ifrs_15();
        // All 5 steps should be present
        assert!(
            ifrs15.iter().any(|e| e.title.contains("Step 1")),
            "Should have Step 1"
        );
        assert!(
            ifrs15.iter().any(|e| e.title.contains("Step 2")),
            "Should have Step 2"
        );
        assert!(
            ifrs15.iter().any(|e| e.title.contains("Step 3")),
            "Should have Step 3"
        );
        assert!(
            ifrs15.iter().any(|e| e.title.contains("Step 4")),
            "Should have Step 4"
        );
        // Step 5 is effectively covered by paragraph 35 (Satisfaction)
        assert!(
            ifrs15.iter().any(|e| e.reference.paragraph == "35"),
            "Should have Step 5 (para 35)"
        );
    }

    #[test]
    fn test_all_standards_count() {
        let all = load_all_standards();
        // Should have significant coverage
        assert!(all.len() >= 40, "Should have at least 40 standards entries");
    }
}
