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

## How to Run Data Analysis

### 1. Prerequisites

Ensure Docker Desktop (version 3.3.0 or later) is installed and running.

### 2. System-Specific Configurations

- **For Windows/Linux users**:  
  - No additional configuration is required.

- **For macOS (Apple Silicon) users**:
  - Enable Rosetta in Docker settings for x86/amd64 emulation.
  - Go to Docker settings (Gear icon) > General > Check "Apple Virtualization Framework" > Check "Use Rosetta for x86/amd64 emulation on Apple Silicon" > Click "Apply & Restart".

### 3. Clone the Repository

If you haven’t already, clone the repository and navigate into the project directory:

```bash
git clone https://github.com/DSCI-310-2025/dsci-310-group-06.git
cd dsci-310-group-06
```

### Running the Analysis

#### **Option 1: Run a One-Time Task Inside the Container (No Need to Visit `localhost:1000`)**

Use this option if you only need to run a one-time task, such as building reports, without interacting with the service on `localhost`.

Navigate to the project root and run:

```bash
docker-compose run --rm report-env make all
```

- This command will:
  - Reset the project.
  - Generate reports in PDF and HTML formats.
  - Automatically remove the container after completing the task.

#### **Option 2: Start Services and Access via `localhost:1000` (Persistent Environment)**

If you want to start services (e.g., a web app or report viewer) and interact with them through a web browser, use this option.

Navigate to the project root and run:

```bash
docker-compose up
```

- This will start the services defined in the Docker Compose configuration and keep them running.
- Open a browser and visit `http://localhost:1000` on a web brower to interact with the service (e.g., view reports or access the web app).
- To generate the entire report while the services are running, run `make all` in the R terminal inside the container.

## List of dependencies needed to run analysis

### R version 4.2.1 and R packages

- `reticulate` (v1.25)  
- `tidyverse` (v2.0.0)  
- `tidymodels` (v1.1.1)  
- `glmnet` (v4.1-8)  
- `patchwork` (v1.3.0)  
- `ROSE` (v0.0-4)  
- `vcd` (v1.4-13)
- `docopt` (v0.7.1)
- `janitor` (v2.2.1)

### Python 3.8 and Python packages

- `pandas` (v2.0.3)
- `ucimlrepo` (v0.0.7)

### Other Dependencies

- GNU Make (v4.2.1)

## Licenses

- MIT License

## References

- Burrows, N. R., Hora, I., Geiss, L. S., Gregg, E. W., & Albright, A. (2017). Incidence of End-Stage Renal Disease Attributed to Diabetes Among Persons with Diagnosed Diabetes — United States and Puerto Rico, 2000–2014. *MMWR Morbidity and Mortality Weekly Report, 66*(43), 1165–1170. [https://doi.org/10.15585/mmwr.mm6643a2](https://doi.org/10.15585/mmwr.mm6643a2)
- CDC. (2017, August 11). *CDC - 2015 BRFSS survey data and Documentation*. Centers for Disease Control and Prevention. [https://www.cdc.gov/brfss/annual_data/annual_2015.html](https://www.cdc.gov/brfss/annual_data/annual_2015.html)
- CDC. (2023, September 25). *CDC diabetes health indicators* [Data set]. UCI Machine Learning Repository. [https://doi.org/10.24432/C53919](https://archive.ics.uci.edu/dataset/891/cdc+diabetes+health+indicators)
- Pickens, C. M., Pierannunzi, C., Garvin, W., & Town, M. (2018). Surveillance for certain health behaviors and conditions among states and selected local areas — Behavioral Risk Factor Surveillance System, United States, 2015. *MMWR Surveillance Summaries, 67*(SS-9), 1–90. [https://doi.org/10.15585/mmwr.ss6709a1](https://doi.org/10.15585/mmwr.ss6709a1)
