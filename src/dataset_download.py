import pandas as pd
from ucimlrepo import fetch_ucirepo

# Fetch dataset
cdc_diabetes_health_indicators = fetch_ucirepo(id=891)

# Data (as pandas DataFrames)
X = cdc_diabetes_health_indicators.data.features
y = cdc_diabetes_health_indicators.data.targets

# Metadata (remove comment if metadata is required to be listed)
# print(cdc_diabetes_health_indicators.metadata)

# Variable information (remove comment if metadata is required to be listed)
# print(cdc_diabetes_health_indicators.variables)

df = pd.concat([X, y], axis=1)
df.to_csv('/home/rstudio/work/data/raw/cdc_diabetes_health_indicators.csv', index=False) # Running from base