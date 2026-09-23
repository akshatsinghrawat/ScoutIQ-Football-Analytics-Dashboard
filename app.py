import streamlit as st
import pandas as pd

# Page config — must be the first Streamlit command
st.set_page_config(
    page_title="ScoutIQ",
    page_icon="⚽",
    layout="wide"
)

# ---- Load data (cached so it doesn't reload on every click) ----
@st.cache_data
def load_data():
    df = pd.read_csv("data/processed/players_final.csv")
    return df

df = load_data()

# ---- Header ----
st.markdown(
    """
    <div style="text-align:center; padding: 10px 0 20px 0;">
        <h1 style="margin-bottom:0;">⚽ ScoutIQ</h1>
        <h4 style="color:gray; font-weight:400; margin-top:5px;">
            Football Player Scouting & Performance Analytics
        </h4>
        <p style="color:gray; font-style:italic;">
            Find players. Compare performance. Discover data-driven insights.
        </p>
    </div>
    """,
    unsafe_allow_html=True
)

st.divider()

# ---- KPI cards ----
col1, col2, col3, col4 = st.columns(4)
col1.metric("Players", df["Player"].nunique())
col2.metric("Clubs", df["Squad"].nunique())
col3.metric("Leagues", df["Comp"].nunique())
col4.metric("Metrics Tracked", df.shape[1])

st.divider()

st.markdown("### Get Started")
st.markdown("""
Use the sidebar to navigate:
- **Player Search** — look up any player's full profile and stats
- **Compare Players** — put two players side by side
- **Explore Players** — filter and discover players by position, league, age, and performance
""")