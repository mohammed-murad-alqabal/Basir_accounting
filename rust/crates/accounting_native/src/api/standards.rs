use super::get_pool;
use accounting_core::standards::registry::StandardsRegistry;
use accounting_core::standards::validator::validate_complete;
use accounting_data::db::standards::PgStandardsRepository;

/// Simple DTO for Standard lookup result
pub struct StandardDto {
    pub reference: String,
    pub title: String,
    pub is_effective: bool,
}

/// Look up a standard by reference string (e.g. "IFRS 15.35")
pub async fn get_standard_info(reference: String) -> anyhow::Result<StandardDto> {
    let pool = get_pool()?;
    let repo = PgStandardsRepository::new(pool.clone());

    // Load registry for validation
    let entries = repo.load_all().await?;
    let registry = StandardsRegistry::from_entries(entries);

    // Validate first (CP-002)
    let std_ref = validate_complete(&reference, &registry)?;

    let entry = registry
        .lookup_ref(&std_ref)
        .ok_or_else(|| anyhow::anyhow!("Standard not found after validation (unexpected)"))?;

    Ok(StandardDto {
        reference: entry.reference.to_canonical(),
        title: entry.title.clone(),
        is_effective: true,
    })
}

/// Search for standards by keyword
pub async fn search_standards(query: String) -> anyhow::Result<Vec<StandardDto>> {
    let pool = get_pool()?;
    let repo = PgStandardsRepository::new(pool.clone());

    let entries = repo.load_all().await?;
    let registry = StandardsRegistry::from_entries(entries);

    let results = registry.search_by_keyword(&query);

    let dtos = results
        .into_iter()
        .map(|e| StandardDto {
            reference: e.reference.to_canonical(),
            title: e.title.clone(),
            is_effective: true,
        })
        .collect();

    Ok(dtos)
}
