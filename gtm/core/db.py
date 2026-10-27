#---------------------beginning-of-code------------------------#
#--------------------------------------------------------------#

# Imports libraries 
import os 
import sqlite3 
from pathlib import Path
#--------------------------------------------------------------#

ROOT = Path(__file__).resolve().parents[2]
DB_PATH = Path(os.getenv("GTM_DB_PATH", ROOT / "data" "gtm.db"))