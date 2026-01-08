CREATE TABLE standards (
    id UUID PRIMARY KEY,
    body TEXT NOT NULL,
    number TEXT NOT NULL,
    paragraph TEXT NOT NULL,
    title TEXT NOT NULL,
    full_text TEXT NOT NULL,
    effective_date DATE NOT NULL,
    supersedes_ids UUID[],
    superseded_by_id UUID,
    
    CONSTRAINT uq_standard_reference UNIQUE (body, number, paragraph)
);
