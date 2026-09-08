//! Zakah Calculation Engine (AAOIFI FAS 9)
//!
//! Implements the Net Zakatable Assets method.

use crate::accounts::models::Account;
use rust_decimal::Decimal;

/// Zakah Calculation Method
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ZakahMethod {
    /// Net Zakatable Assets method (Standard for businesses)
    NetAssets,
    /// Net Invested Funds method (Used by some Islamic Financial Institutions)
    NetFunds,
}

/// Calendar type for Zakah calculation
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ZakahCalendarType {
    /// Hijri (354 days) - Rate: 2.5%
    Hijri,
    /// Gregorian (365 days) - Rate: 2.5775%
    Gregorian,
}

impl ZakahCalendarType {
    pub fn rate(&self) -> Decimal {
        match self {
            ZakahCalendarType::Hijri => Decimal::from_str_radix("0.025", 10).unwrap(),
            ZakahCalendarType::Gregorian => Decimal::from_str_radix("0.025775", 10).unwrap(),
        }
    }
}

pub struct ZakahBase {
    pub zakatable_assets: Vec<(Account, Decimal)>,
    pub deductible_liabilities: Vec<(Account, Decimal)>,
}

impl ZakahBase {
    pub fn net_zakatable_assets(&self) -> Decimal {
        let assets: Decimal = self.zakatable_assets.iter().map(|(_, b)| b.abs()).sum();
        let liab: Decimal = self
            .deductible_liabilities
            .iter()
            .map(|(_, b)| b.abs())
            .sum();
        assets - liab
    }
}

pub struct ZakahCalculator;

impl ZakahCalculator {
    /// Calculate Zakah based on AAOIFI FAS 9.
    pub fn calculate(base: &ZakahBase, calendar: ZakahCalendarType) -> Decimal {
        let net = base.net_zakatable_assets();
        if net <= Decimal::ZERO {
            return Decimal::ZERO;
        }

        let zakah = net * calendar.rate();
        zakah.round_dp(2)
    }
}
