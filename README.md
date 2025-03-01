# Predicting the Risk of Diabetes using Logistic Regression

## Contributors

- Nicholas Tam
- Dua Khan
- Kaylee Li
- Luke Huang

## Project Summary

The Behavioral Risk Factor Surveillance System (BRFSS) is a collaborative project between all of the states in the United States (US) and participating US territories and the Centers for Disease Control and Prevention (CDC), with the aim to collect uniform, state-specific data on preventive health practices and risk behaviors that are linked to chronic diseases, injuries, and preventable infectious diseases that affect the adult population (Centers for Disease Control and Prevention, 2017).

Our project aims to predict if an individual is at high risk of developing diabetes based on the health indicators provided by the BRFSS, using a cleaned diabetes dataset derived from the BRFSS 2015 survey responses. The majority of attributes are categorical and binary due to the nature of the survey questions.

The original dataset can be found on the [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)

## How to run data analysis

1. Setup: Ensure Docker Desktop is installed and running.
2. Start container: In the project directory (dsci-310-group-06), run the following in the terminal:

```{terminal}
docker-compose up
```

3. Open `http://localhost:10000/` in a browser.
4. Open `work/projects/diabetes_classification_report.ipynb` and run the notebook.

## List of dependencies needed to run analysis

- `reticulate`
- `tidyverse`
- `tidymodels`
- `glmnet`
- `patchwork`
- `ROSE`
- `vcd`

## Licenses

- MIT License

## References

- Burrows, N. R., Hora, I., Geiss, L. S., Gregg, E. W., & Albright, A. (2017). Incidence of End-Stage Renal Disease Attributed to Diabetes Among Persons with Diagnosed Diabetes — United States and Puerto Rico, 2000–2014. *MMWR Morbidity and Mortality Weekly Report, 66*(43), 1165–1170. [https://doi.org/10.15585/mmwr.mm6643a2](https://doi.org/10.15585/mmwr.mm6643a2)
- CDC. (2023, September 25). *CDC diabetes health indicators* [Data set]. UCI Machine Learning Repository. [https://doi.org/10.24432/C53919](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)
- CDC. (2017, August 11). *CDC - 2015 BRFSS survey data and Documentation*. Centers for Disease Control and Prevention. [https://www.cdc.gov/brfss/annual_data/annual_2015.html](https://www.cdc.gov/brfss/annual_data/annual_2015.html)
