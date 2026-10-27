#---------------------beginning-of-code------------------------#
#--------------------------------------------------------------#

# Imports Libraries 
import argparse
import shutil 
from datetime import datetime, timezone
from gtm.core.db import ROOT, get_conn
#--------------------------------------------------------------#

# Main function call 
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("name", help="lowercase name")
    parser.add_argument("--template", default="b2b")
    args = parser.parse_args()
    name = args.name.lower()

    # 1. Builds the config folder, copied from the template
    client_dir = ROOT / "config" / "clients" / name 
    if client_dir.exists():
        print(f"Config for {name} already exists, so leaving this untouched.")
    else:
        (client_dir / "voice").mkdir(parents=True)
        (client_dir / "test_sets").mkdir()
        shutil.copy(ROOT / "config" / "templates" / f"{args.template}.yaml",
                    client_dir / "config.yaml")
        (client_dir / "voice" / "samples.md").touch()

    # 2. Inbox and output folders 
    for sub in ("data/inbox/{n}/linkedin", "data/inbox/{n}/connections",
                "outputs/{n}/briefs", "outputs/{n}/people", "outputs/{n}/drafts"):
        (ROOT / sub.format(n=name)).mkdir(parents=True, exist_ok=True)

    # 3. Adds a row in the clients table 
    conn = get_conn
    conn.execute(
        "INSERT INTO clients (name, config_path, created_at) VALUES (?, ?, ?) "
        "ON CONFLICT (name) DO NOTHING",
        (name, f"config/clients/{name}/config.yaml",
        datetime.now(timezone.utc).isoformat()),
    )
    conn.commit()
    conn.close()
    print(f"Client {name} ready. Fill in {client_dir / 'config.yaml'}")

if __name__ == '__main__':
    main()
#--------------------------------------------------------------#
#---------------------end-of-code------------------------#