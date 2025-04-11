import pandas as pd
from ucimlrepo import fetch_ucirepo

try:
    cdc_diabetes_health_indicators = fetch_ucirepo(id=891)

    # Data (as pandas DataFrames)
    X = cdc_diabetes_health_indicators.data.features
    y = cdc_diabetes_health_indicators.data.targets

    df = pd.concat([X, y], axis=1)
    df.to_csv('~/work/data/raw/cdc_diabetes_health_indicators.csv', index=False)
    print("Dataset fetched and saved successfully.")

except Exception as e:
    try:
        # Try loading the existing file if fetching failed
        df = pd.read_csv('~/work/data/raw/cdc_diabetes_health_indicators.csv')
        print(f"Fetch failed with error: {e}. Server on UCI likely down. Loaded existing file instead.")
    except Exception as read_error:
        raise RuntimeError(f"Failed to fetch dataset and could not load existing file: {read_error}")
