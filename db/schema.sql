-- Creates a table called clients that holds all clients directory that we serve

CREATE TABLE IF NOT EXISTS clients (
    id INTEGER PRIMARY KEY,
    name TEXT UNIQUE, 
    config_path TEXT, 
    created_at TEXT
)

-- Companies we sell to 

CREATE TABLE IF NOT EXISTS companies (
    id INTEGER PRIMARY KEY, 
    client_id INTEGER,
    name TEXT, 
    domain TEXT, 
    linkedin_url TEXT,
    industry TEXT,
    country TEXT,
    employee_count INTEGER,
    erp_system TEXT,
    description TEXT,
    fit_score INTEGER,
    enriched_at TEXT,
    created_at TEXT,
    UNIQUE (cliend_id, domain)
)

-- People at the companies 
CREATE TABLE IF NOT EXISTS people (
    id INTEGER PRIMARY KEY, client_id INTEGER, company_id INTEGER,
    full_name TEXT, title TEXT, seniority TEXT,
    linkedin_url TEXT, email TEXT,
    source TEXT,
    fit_score INTEGER,
    signal_score INTEGER,
    total_score INTEGER,
    reason TEXT,
    status TEXT DEFAULT 'new',
    enriched_at TEXT,
    created_at TEXT,
    UNIQUE (client_id, linkedin_url)
)

-- Events that make a company worth contacting now 
CREATE TABLE IF NOT EXISTS signals (
    id INTEGER PRIMARY KEY, client_id INTEGER,
    company_id INTEGER, person_id INTEGER,
    type TEXT,
    detail TEXT, source_url TEXT,
    points INTEGER, detected_at TEXT
)

-- Raw Linkedin pastes

CREATE TABLE IF NOT EXISTS captures (
    id INTEGER PRIMARY KEY, client_id INTEGER,
    capture_type TEXT,
    context TEXT,
    raw_text TEXT, parsed INTEGER DEFAULT 0, captured_at TEXT
)

-- Market Intelligence 
CREATE TABLE IF NOT EXISTS content_items (
    id INTEGER PRIMARY KEY, 
    client_id INTEGER,
    platform TEXT, 
    external_id TEXT,
    url TEXT,
    author_id INTEGER,
    community TEXT,
    title TEXT,
    body TEXT,
    published_at TEXT,
    likes INTEGER,
    comments INTEGER,
    shares INTEGER,
    views INTEGER,
    is_relevant INTEGER,
    theme TEXT,
    is_question INTEGER,
    sentiment TEXT,
    captured_at TEXT,
    UNIQUE (client_id, platform, external_id)
)

-- Creators, publications and frequent commenters 
CREATE TABLE IF NOT EXISTS authors (
    id INTEGER PRIMARY KEY, client_id INTEGER,
    platform TEXT, handle TEXT, name TEXT, profile_url TEXT,
    followers INTEGER, type TEXT,
    relevant_posts INTEGER, avg_engagement REAL,
    person_id INTEGER,
    UNIQUE (client_id, platform, handle)
)

-- Content ideas and drafts 
CREATE TABLE IF NOT EXISTS ideas (
    id INTEGER PRIMARY KEY, client_id INTEGER,
    source TEXT,
    pillar TEXT,
    idea TEXT,
    evidence TEXT,
    status TEXT DEFAULT 'new',
    created_at TEXT 
)

CREATE TABLE IF NOT EXISTS drafts (
    id INTEGER PRIMARY KEY,
    idea_id INTEGER,
    platform TEXT,
    draft TEXT,
    final_text TEXT,
    status TEXT,
    created_at TEXT 
)

CREATE TABLE IF NOT EXISTS feedback(
    id INTEGER PRIMARY KEY,
    client_id INTEGER,
    item_type TEXT,
    item_id INTEGER,
    verdict TEXT,
    note TEXT,
    created_at TEXT
)

-- Cost and debugging 
CREATE TABLE IF NOT EXISTS llm_calls (
    id INTEGER PRIMARY KEY,
    client_id INTEGER,
    task TEXT,
    input_tokens INTEGER,
    output_tokens INTEGER,
    cost_usd REAL,
    created_at TEXT
)


CREATE TABLE IF NOT EXISTS llm_cache (
    key TEXT PRIMARY KEY,
    task TEXT,
    response TEXT,
    created_at TEXT 
)