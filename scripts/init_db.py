#---------------------beginning-of-code------------------------#
#--------------------------------------------------------------#

# Imports libraries 
from datetime import datetime, timezone
from gtm.core.db import ROOT, DB_PATH, get_conn
#--------------------------------------------------------------#

# Declares global variables 
FOLDERS = [
    "data/cache",
    "data/inbox/vizcorn/linkedin",
    "data/inbox/vizcorn/connections",
    "outputs/vizcorn/briefs",
    "outputs/vizcorn/people",
    "outputs/vizcorn/drafts"
]
#--------------------------------------------------------------#
def main():
    for folder in FOLDERS:
        (ROOT / folder).mkdir(parents=True, exist_ok=True)

    schema = (ROOT / "db" / "schema.sql").read_text()
    conn = get_conn()
    conn.executescript(schema)
    conn.execute(
        "INSERT OR IGNORE INTO clients (name, config_path, created_at) VALUES (?, ?, ?)",
        ("vizcorn", "config/clients/vizcorn/config.yaml", datetime.now(timezone.utc).isoformat())
    )
    conn.commit()
    conn.close()
    print(f"Database ready at {DB_PATH}")

if __name__ == "__main__":
    main()
#--------------------------------------------------------------#
#---------------End-of-code------------------------------------#