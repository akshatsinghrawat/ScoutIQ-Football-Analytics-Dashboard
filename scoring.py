import pandas as pd


POSITION_WEIGHTS = {
    "FW": {
        "Goals_per90": 0.35,
        "Assists_per90": 0.15,
        "GC_per90": 0.20,
        "SCA90": 0.15,
        "GCA90": 0.15
    },

    "MF": {
        "Assists_per90": 0.20,
        "GC_per90": 0.15,
        "SCA90": 0.25,
        "GCA90": 0.20,
        "Cmp%": 0.20
    },

    "DF": {
        "Tkl_per90": 0.25,
        "Int_per90": 0.25,
        "Clr_per90": 0.20,
        "Cmp%": 0.15,
        "GC_per90": 0.15
    },

    "GK": {
        "Save%": 0.45,
        "CS%": 0.30,
        "PSxG+/-": 0.25
    },
}


MIN_MINUTES_FOR_SCORE = 900


def add_scoutiq_scores(df: pd.DataFrame) -> pd.DataFrame:

    df = df.copy()

    # Primary position = first position listed
    df["primary_pos"] = df["Pos"].apply(
        lambda p: p.split(",")[0]
    )

    # Calculate defensive stats per 90 minutes
    df["Tkl_per90"] = (
        df["Tkl"] / df["Min"]
    ) * 90

    df["Int_per90"] = (
        df["Int"] / df["Min"]
    ) * 90

    df["Clr_per90"] = (
        df["Clr"] / df["Min"]
    ) * 90

    # Players need at least 900 minutes
    df["qualified"] = df["Min"] >= MIN_MINUTES_FOR_SCORE

    # Start with no score
    df["ScoutIQ_Score"] = None

    # Calculate score separately for each position
    for pos, weights in POSITION_WEIGHTS.items():

        group_mask = (
            (df["primary_pos"] == pos)
            & (df["qualified"])
        )

        group = df[group_mask]

        if group.empty:
            continue

        score = pd.Series(
            0.0,
            index=group.index
        )

        for metric, weight in weights.items():

            percentile = (
                group[metric].rank(pct=True)
                * 100
            )

            score += (
                percentile.fillna(0)
                * weight
            )

        df.loc[group_mask, "ScoutIQ_Score"] = (
            score.round(0)
        )

    return df