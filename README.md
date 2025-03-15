# Predicting the Risk of Diabetes using Logistic Regression

## Contributors

- Nicholas Tam
- Dua Khan
- Kaylee Li
- Luke Huang

## Project Summary

The Behavioral Risk Factor Surveillance System (BRFSS) is a collaborative project between all of the states in the United States (US) and participating US territories and the Centers for Disease Control and Prevention (CDC), with the aim to collect uniform, state-specific data on preventive health practices and risk behaviors that are linked to chronic diseases, injuries, and preventable infectious diseases that affect the adult population (Pickens et al., 2018).

Our project aims to predict if an individual is at high risk of developing diabetes based on the health indicators provided by the BRFSS, using a cleaned diabetes dataset derived from the BRFSS 2015 survey responses. The majority of attributes are categorical and binary due to the nature of the survey questions (CDC, 2017). Our project highlights the importance of using key health indicators such as general health, high blood pressure, age and high cholesterol in diabetes prediction. The use of Cramér’s V helped in selecting the most relevant features, reducing unnecessary complexity and improving the interpretability of the model. Moreover, to address the imbalance in the dataset, synthetic resampling (ROSE method) was applied to ensure that both diabetic and non-diabetic cases were equally represented, improving the model’s generalizability.
 
 Our model effectively predicts diabetes risk with 75.43% recall, correctly identifying most diabetic cases. Its AUC of 0.7989 shows strong discrimination between diabetic and non-diabetic cases. Key predictors include general health, high blood pressure, age, high cholesterol, and difficulty walking. Synthetic resampling (ROSE) balanced the dataset, improving model performance. However, a ~25% false negative rate highlights the need for refinement. The study demonstrates the potential of data-driven early detection to aid diabetes prevention.
 

The original dataset can be found on the [UCI Machine Learning Repository](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)

## How to run data analysis

1. Prerequisites: Ensure Docker Desktop is installed and running.

2. For Mac users: Enable Rosetta in Docker settings:

- Open Docker Settings > General

- Check Use Virtualization Framework

- Check Use Rosetta for x86/amd64 emulation on Apple Silicon

3. Clone the repository (if not already done):

```bash
git clone https://github.com/DSCI-310-2025/dsci-310-group-06.git
cd dsci-310-group-06
```

4. Start container: In the project directory (`dsci-310-group-06/`), run the following in the terminal:

```{terminal}
docker-compose up
```

5. Open `http://localhost:10000/` in a browser.

6. Navigate to `work/reports/diabetes_classification_report.qmd` and run the notebook.

## List of dependencies needed to run analysis

#### R
- `reticulate` (v1.25)  
- `tidyverse` (v2.0.0)  
- `tidymodels` (v1.1.1)  
- `glmnet` (v4.1-8)  
- `patchwork` (v1.3.0)  
- `ROSE` (v0.0-4)  
- `vcd` (v1.4-13)

#### Python
- `pandas` (v2.2)
- `ucimlrepo` (v0.0.7)

## Licenses

- MIT License

## References

- Burrows, N. R., Hora, I., Geiss, L. S., Gregg, E. W., & Albright, A. (2017). Incidence of End-Stage Renal Disease Attributed to Diabetes Among Persons with Diagnosed Diabetes — United States and Puerto Rico, 2000–2014. *MMWR Morbidity and Mortality Weekly Report, 66*(43), 1165–1170. [https://doi.org/10.15585/mmwr.mm6643a2](https://doi.org/10.15585/mmwr.mm6643a2)
- CDC. (2017, August 11). *CDC - 2015 BRFSS survey data and Documentation*. Centers for Disease Control and Prevention. [https://www.cdc.gov/brfss/annual_data/annual_2015.html](https://www.cdc.gov/brfss/annual_data/annual_2015.html)
- CDC. (2023, September 25). *CDC diabetes health indicators* [Data set]. UCI Machine Learning Repository. [https://doi.org/10.24432/C53919](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)
- Pickens, C. M., Pierannunzi, C., Garvin, W., & Town, M. (2018). Surveillance for certain health behaviors and conditions among states and selected local areas — Behavioral Risk Factor Surveillance System, United States, 2015. *MMWR Surveillance Summaries, 67*(SS-9), 1–90. [https://doi.org/10.15585/mmwr.ss6709a1](https://doi.org/10.15585/mmwr.ss6709a1)
