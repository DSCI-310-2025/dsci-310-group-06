.PHONY: all clean report

all:
	make clean
	make index.html

report:
	make index.html

# output-dir from _quarto.yml is docs, so moving is unnecessary
index.html: /home/rstudio/work/output/checking_raw_df.csv \
	/home/rstudio/work/output/target_result.csv \
	/home/rstudio/work/output/balanced_target_result.csv \
	/home/rstudio/work/output/balanced_raw_comparision_df.csv \
	/home/rstudio/work/output/combined_plots.png \
	/home/rstudio/work/output/cramer_chi_results_sorted.csv \
	/home/rstudio/work/output/lasso_tuned_wflow.RDS \
	/home/rstudio/work/output/lasso_metrics.csv \
	/home/rstudio/work/output/roc_curve.png \
	/home/rstudio/work/output/cm_plot.png \
	/home/rstudio/work/reports/diabetes_classification_report.html \
	/home/rstudio/work/reports/diabetes_classification_report.pdf
	cp /home/rstudio/work/reports/diabetes_classification_report.html /home/rstudio/work/docs/index.html # Recreate in docs

# From 01-load_clean.R
/home/rstudio/work/output/checking_raw_df.csv /home/rstudio/work/output/target_result.csv /home/rstudio/work/output/balanced_target_result.csv /home/rstudio/work/output/balanced_raw_comparision_df.csv /home/rstudio/work/data/processed/diabetes_train.csv /home/rstudio/work/data/processed/diabetes_test.csv: 01-load_clean.R \
	/venv/bin/python \
	/home/rstudio/work/src/dataset_download.py \
	/home/rstudio/work/data/raw/cdc_diabetes_health_indicators.csv
	Rscript 01-load_clean.R \
	--python_path=/venv/bin/python \
	--extract_path=/home/rstudio/work/src/dataset_download.py \
	--file_path=/home/rstudio/work/data/raw/cdc_diabetes_health_indicators.csv \
	--output_path_raw=/home/rstudio/work/output/checking_raw_df.csv \
	--output_path_target=/home/rstudio/work/output/target_result.csv \
	--output_path_bal=/home/rstudio/work/output/balanced_target_result.csv \
	--output_path_df=/home/rstudio/work/output/balanced_raw_comparision_df.csv \
	--output_path_train=/home/rstudio/work/data/processed/diabetes_train.csv \
	--output_path_test=/home/rstudio/work/data/processed/diabetes_test.csv

# From 02-eda.R
/home/rstudio/work/output/combined_plots.png /home/rstudio/work/output/cramer_chi_results_sorted.csv: 02-eda.R \
	/home/rstudio/work/data/processed/diabetes_train.csv
	Rscript 02-eda.R \
	--file_path=/home/rstudio/work/data/processed/diabetes_train.csv \
	--output_path_plots=/home/rstudio/work/output/combined_plots.png \
	--output_path_cramers=/home/rstudio/work/output/cramer_chi_results_sorted.csv

# From 03-model.R
/home/rstudio/work/output/lasso_tuned_wflow.RDS: 03-model.R /home/rstudio/work/data/processed/diabetes_train.csv 
	Rscript 03-model.R \
	--file_path=/home/rstudio/work/data/processed/diabetes_train.csv \
	--output_path=/home/rstudio/work/output/lasso_tuned_wflow.RDS

# From 04-analysis.R
/home/rstudio/work/output/lasso_metrics.csv /home/rstudio/work/output/roc_curve.png /home/rstudio/work/output/cm_plot.png: 04-analysis.R /home/rstudio/work/data/processed/diabetes_test.csv /home/rstudio/work/output/lasso_tuned_wflow.RDS 
	Rscript 04-analysis.R \
	--file_path_test=/home/rstudio/work/data/processed/diabetes_test.csv \
	--file_path_wflow=/home/rstudio/work/output/lasso_tuned_wflow.RDS \
	--output_path_lasso=/home/rstudio/work/output/lasso_metrics.csv \
	--output_path_roc=/home/rstudio/work/output/roc_curve.png \
	--output_path_cm=/home/rstudio/work/output/cm_plot.png

# render quarto report in HTML and PDF using /home/rstudio/work/output /home/rstudio/work/reports/diabetes_classification_report.qmd
/home/rstudio/work/reports/diabetes_classification_report.html: /home/rstudio/work/output /home/rstudio/work/reports/diabetes_classification_report.qmd
	quarto render /home/rstudio/work/reports/diabetes_classification_report.qmd --to html

/home/rstudio/work/reports/diabetes_classification_report.pdf: /home/rstudio/work/output /home/rstudio/work/reports/diabetes_classification_report.qmd
	quarto render /home/rstudio/work/reports/diabetes_classification_report.qmd --to pdf

clean:
	rm -rf /home/rstudio/work/output/*
	rm -rf /home/rstudio/work/data/processed/*
	rm -f *.pdf
	rm -rf /home/rstudio/work/docs/* # Remove docs directory, r to make it recursive
	rm -rf /home/rstudio/work/reports/diabetes_classification_report.html \
		/home/rstudio/work/reports/diabetes_classification_report.pdf
