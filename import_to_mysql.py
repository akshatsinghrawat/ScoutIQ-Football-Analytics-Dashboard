import pandas as pd
from sqlalchemy import create_engine

# CSV file path
csv_path = r"C:\Users\aksha\OneDrive\Desktop\Scout IQ\data\processed\players_final.csv"

# Read CSV
df = pd.read_csv(csv_path)

print(f"Loaded {len(df)} rows and {len(df.columns)} columns")

# MySQL connection
engine = create_engine(
    "mysql+pymysql://root:wakanda1211@localhost/scoutiq"
)

# Import to MySQL
df.to_sql(
    name="players",
    con=engine,
    if_exists="replace",
    index=False,
    chunksize=500
)

print("✅ Import completed successfully!")