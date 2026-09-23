import streamlit as st
import pandas as pd
import plotly.graph_objects as go

st.set_page_config(page_title="Compare Players — ScoutIQ", page_icon="⚖️", layout="wide")

@st.cache_data
def load_data():
    df = pd.read_csv("data/processed/players_final.csv")
    df["display_label"] = df["Player"] + " — " + df["Squad"]
    return df

df = load_data()

st.title("⚖️ Compare Players")

col1, col2 = st.columns(2)
with col1:
    label_a = st.selectbox("Player A", sorted(df["display_label"].unique()), key="player_a")
with col2:
    label_b = st.selectbox(
        "Player B",
        sorted(df["display_label"].unique()),
        index=1,
        key="player_b"
    )

player_a = df[df["display_label"] == label_a].iloc[0]
player_b = df[df["display_label"] == label_b].iloc[0]

st.divider()

# ---- Comparison table ----
st.subheader("Head-to-Head Stats")

compare_fields = {
    "Club": "Squad",
    "Position": "Pos",
    "Age": "Age",
    "League": "Comp",
    "Minutes Played": "Min",
    "Goals": "Gls",
    "Assists": "Ast",
    "Goal Contributions": "Goal_Contributions",
    "xG": "xG",
    "xAG": "xAG",
    "Shots": "Sh",
    "Shots on Target": "SoT",
    "Pass Completion %": "Cmp%",
    "Key Passes": "KP",
    "Tackles": "Tkl",
    "Interceptions": "Int",
    "Goals per 90": "Goals_per90",
    "Assists per 90": "Assists_per90",
}

comparison_df = pd.DataFrame({
    "Metric": compare_fields.keys(),
    player_a["Player"]: [player_a[col] for col in compare_fields.values()],
    player_b["Player"]: [player_b[col] for col in compare_fields.values()],
})

st.dataframe(comparison_df, use_container_width=True, hide_index=True)

st.divider()

# ---- Radar chart overlay ----
st.subheader("Per-90 Profile Comparison")

radar_fields = {
    "Goals/90": "Goals_per90",
    "Assists/90": "Assists_per90",
    "GC/90": "GC_per90",
    "SCA/90": "SCA90",
    "GCA/90": "GCA90",
}

fig = go.Figure()
fig.add_trace(go.Scatterpolar(
    r=[player_a[col] for col in radar_fields.values()],
    theta=list(radar_fields.keys()),
    fill='toself',
    name=player_a["Player"]
))
fig.add_trace(go.Scatterpolar(
    r=[player_b[col] for col in radar_fields.values()],
    theta=list(radar_fields.keys()),
    fill='toself',
    name=player_b["Player"]
))
fig.update_layout(
    polar=dict(radialaxis=dict(visible=True)),
    showlegend=True,
    height=500
)
st.plotly_chart(fig, use_container_width=True)