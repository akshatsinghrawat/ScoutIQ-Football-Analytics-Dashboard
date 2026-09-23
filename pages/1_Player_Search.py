import streamlit as st
import pandas as pd
import plotly.graph_objects as go

from scoring import add_scoutiq_scores

st.set_page_config(page_title="Player Search — ScoutIQ", page_icon="🔍", layout="wide")

@st.cache_data
def load_data():
    return pd.read_csv("data/processed/players_final.csv")

df = load_data()
df = add_scoutiq_scores(df)

st.title("🔍 Player Search")

# Build a unique label for each row: "Name — Club" (handles transferred players)
df["display_label"] = df["Player"] + " — " + df["Squad"]

player_label = st.selectbox("Select Player", sorted(df["display_label"].unique()))
player = df[df["display_label"] == player_label].iloc[0]

score = player["ScoutIQ_Score"]

st.subheader("ScoutIQ Score")

if pd.isna(score):
    st.warning("Insufficient minutes for a reliable ScoutIQ Score.")
else:
    st.metric("ScoutIQ Score", f"{int(score)}/100")

    
st.divider()

# ---- Profile header ----
col1, col2, col3, col4 = st.columns(4)
col1.metric("Club", player["Squad"])
col2.metric("Position", player["Pos"])
col3.metric("Age", int(player["Age"]) if pd.notna(player["Age"]) else "N/A")
col4.metric("League", player["Comp"])

st.divider()

# ---- Key stats ----
st.subheader("Key Statistics")

s1, s2, s3, s4, s5 = st.columns(5)
s1.metric("Goals", int(player["Gls"]))
s2.metric("Assists", int(player["Ast"]))
s3.metric("Goal Contributions", int(player["Goal_Contributions"]))
s4.metric("Minutes Played", int(player["Min"]))
s5.metric("xG", round(player["xG"], 2))

st.divider()

# ---- Bar chart: core attacking stats ----
st.subheader("Performance Breakdown")

bar_stats = {
    "Goals": player["Gls"],
    "Assists": player["Ast"],
    "xG": player["xG"],
    "xAG": player["xAG"],
    "Shots": player["Sh"],
    "Shots on Target": player["SoT"],
}

fig_bar = go.Figure(go.Bar(
    x=list(bar_stats.keys()),
    y=list(bar_stats.values()),
    marker_color="#2E86DE"
))
fig_bar.update_layout(height=400, yaxis_title="Value")
st.plotly_chart(fig_bar, use_container_width=True)

# ---- Radar chart: per-90 profile ----
st.subheader("Per-90 Profile")

radar_stats = {
    "Goals/90": player["Goals_per90"],
    "Assists/90": player["Assists_per90"],
    "GC/90": player["GC_per90"],
    "SCA/90": player["SCA90"],
    "GCA/90": player["GCA90"],
}

fig_radar = go.Figure()
fig_radar.add_trace(go.Scatterpolar(
    r=list(radar_stats.values()),
    theta=list(radar_stats.keys()),
    fill='toself',
    name=player["Player"]
))
fig_radar.update_layout(
    polar=dict(radialaxis=dict(visible=True)),
    showlegend=False,
    height=450
)
st.plotly_chart(fig_radar, use_container_width=True)