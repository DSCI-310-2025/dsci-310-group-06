# Diabetes Classification

## Contributors

- Nicholas Tam
- Dua Khan
- Kaylee Li
- Luke Huang

## Project Summary

The Behavioral Risk Factor Surveillance System (BRFSS) is a collaborative project between all of the states in the United States (US) and participating US territories and the Centers for Disease Control and Prevention (CDC), with the aim to collect uniform, state-specific data on preventive health practices and risk behaviors that are linked to chronic diseases, injuries, and preventable infectious diseases that affect the
adult population (Centers for Disease Control and Prevention, 2017).

Our project aims to classify people with or without diabetes based on the factors provided by the BRFSS, using a cleaned diabetes dataset derived from the BRFSS 2015 dataset. The majority of attributes are binary due to being derived from binary responses in the BRFSS 2015.

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
- `patchwork`
- `ROSE`
- `purrr`

## Licenses

- MIT License

## References

- Centers for Disease Control and Prevention. (2023, September 25). CDC diabetes health indicators. UCI Machine Learning Repository. [https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)
- Centers for Disease Control and Prevention. (2017, August 11). CDC - 2015 BRFSS survey data and Documentation. [https://www.cdc.gov/brfss/annual_data/annual_2015.html](https://www.cdc.gov/brfss/annual_data/annual_2015.html)
- Burrows, N. R., Hora, I., Geiss, L. S., Gregg, E. W., & Albright, A. (2017, November 2). Incidence of End-Stage Renal Disease Attributed to Diabetes Among Persons with Diagnosed Diabetes — United States and Puerto Rico, 2000–2014. MMWR Morb Mortal Wkly Rep 2017. [http://dx.doi.org/10.15585/mmwr.mm6643a2](http://dx.doi.org/10.15585/mmwr.mm6643a2)
