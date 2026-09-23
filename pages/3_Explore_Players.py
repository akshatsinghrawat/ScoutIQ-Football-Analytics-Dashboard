import streamlit as st
import pandas as pd

st.set_page_config(page_title="Explore Players — ScoutIQ", page_icon="🧭", layout="wide")

@st.cache_data
def load_data():
    return pd.read_csv("data/processed/players_final.csv")

df = load_data()

st.title("🧭 Explore Players")
st.caption("Filter and discover players based on your scouting criteria.")

st.divider()

# ---- Filters ----
st.sidebar.header("Filters")

leagues = st.sidebar.multiselect(
    "League", sorted(df["Comp"].unique()), default=sorted(df["Comp"].unique())
)

# Break combo positions like "FW,MF" into individual categories
all_position_categories = sorted(set(
    p.strip() for combo in df["Pos"].unique() for p in combo.split(",")
))

positions = st.sidebar.multiselect(
    "Position", all_position_categories, default=all_position_categories
)

position_match_mode = st.sidebar.radio(
    "Position Matching",
    ["Any selected position", "All selected positions"]
)

clubs = st.sidebar.multiselect(
    "Club (optional)", sorted(df["Squad"].unique())
)

age_min, age_max = int(df["Age"].min()), int(df["Age"].max())
age_range = st.sidebar.slider("Age Range", age_min, age_max, (age_min, age_max))

min_minutes = st.sidebar.slider(
    "Minimum Minutes Played", 0, int(df["Min"].max()), 450
)

min_gc = st.sidebar.slider(
    "Minimum Goal Contributions", 0, int(df["Goal_Contributions"].max()), 0
)

# ---- Apply filters ----
filtered = df[
    (df["Comp"].isin(leagues)) &
    (df["Pos"].apply(
        lambda p: (
            any(pos in p.split(",") for pos in positions)
            if position_match_mode == "Any selected position"
            else all(pos in p.split(",") for pos in positions)
        )
    )) &
    (df["Age"].between(age_range[0], age_range[1])) &
    (df["Min"] >= min_minutes) &
    (df["Goal_Contributions"] >= min_gc)
]

if clubs:
    filtered = filtered[filtered["Squad"].isin(clubs)]

st.subheader(f"Results: {len(filtered)} players")

display_cols = [
    "Player", "Squad", "Comp", "Pos", "Age", "Min",
    "Gls", "Ast", "Goal_Contributions", "Goals_per90",
    "Assists_per90", "xG", "xAG"
]

sort_col = st.selectbox("Sort by", display_cols, index=display_cols.index("Goal_Contributions"))
sort_desc = st.checkbox("Descending order", value=True)

result_df = filtered[display_cols].sort_values(sort_col, ascending=not sort_desc)

st.dataframe(result_df, use_container_width=True, hide_index=True)

# ---- Export ----
csv = result_df.to_csv(index=False).encode("utf-8")
st.download_button("Download results as CSV", csv, "scoutiq_filtered_players.csv", "text/csv")