.PHONY: all clean report

all:
	make clean
	make index.html

report:
	make index.html

clean:
	rm -rf work/output/*
	rm -rf work/data/processed/*
	rm -rf work/data/raw/*
	rm -rf work/docs/*
	rm -rf work/reports/diabetes_classification_report.html \
		work/reports/diabetes_classification_report.pdf

index.html: work/output/checking_raw_matrix.RDS \
	work/output/target_result.csv \
	work/output/balanced_target_result.csv \
	work/output/balanced_raw_comparision_df.csv \
	work/output/combined_plots.png \
	work/output/cramer_chi_results_sorted.csv \
	work/output/lasso_tuned_wflow.RDS \
	work/output/lasso_metrics.csv \
	work/output/roc_curve.png \
	work/output/cm_plot.png \
	work/output/cm_df.csv \
	work/reports/diabetes_classification_report.html \
	work/reports/diabetes_classification_report.pdf
	cp work/reports/diabetes_classification_report.html work/docs/index.html

# From 01-load_clean.R
work/output/checking_raw_matrix.RDS work/output/target_result.csv work/output/balanced_target_result.csv work/output/balanced_raw_comparision_df.csv work/data/processed/diabetes_train.csv work/data/processed/diabetes_test.csv: work/src/01-load_clean.R /venv/bin/python work/src/dataset_download.py
	Rscript work/src/01-load_clean.R \
	--python_path=/venv/bin/python \
	--extract_path=work/src/dataset_download.py \
	--file_path=work/data/raw/cdc_diabetes_health_indicators.csv \
	--output_path_raw=work/output/checking_raw_matrix.RDS \
	--output_path_target=work/output/target_result.csv \
	--output_path_bal=work/output/balanced_target_result.csv \
	--output_path_df=work/output/balanced_raw_comparision_df.csv \
	--output_path_train=work/data/processed/diabetes_train.csv \
	--output_path_test=work/data/processed/diabetes_test.csv

# From 02-eda.R
work/output/combined_plots.png work/output/cramer_chi_results_sorted.csv: work/src/02-eda.R work/data/processed/diabetes_train.csv
	Rscript work/src/02-eda.R \
	--file_path=work/data/processed/diabetes_train.csv \
	--output_path_plots=work/output/combined_plots.png \
	--output_path_cramers=work/output/cramer_chi_results_sorted.csv

# From 03-model.R
work/output/lasso_tuned_wflow.RDS: work/src/03-model.R work/data/processed/diabetes_train.csv 
	Rscript work/src/03-model.R \
	--file_path=work/data/processed/diabetes_train.csv \
	--output_path=work/output/lasso_tuned_wflow.RDS

# From 04-analysis.R
work/output/lasso_metrics.csv work/output/roc_curve.png work/output/cm_plot.png work/output/cm_df.csv: work/src/04-analysis.R work/data/processed/diabetes_test.csv work/output/lasso_tuned_wflow.RDS 
	Rscript work/src/04-analysis.R \
  --file_path_test=work/data/processed/diabetes_test.csv \
  --file_path_wflow=work/output/lasso_tuned_wflow.RDS \
  --output_path_lasso=work/output/lasso_metrics.csv \
  --output_path_roc=work/output/roc_curve.png \
  --output_path_cm=work/output/cm_plot.png \
  --output_path_cm_df=work/output/cm_df.csv

# render quarto report in HTML and PDF using work/output work/reports/diabetes_classification_report.qmd
work/reports/diabetes_classification_report.html: work/output work/reports/diabetes_classification_report.qmd
	quarto render work/reports/diabetes_classification_report.qmd --to html

work/reports/diabetes_classification_report.pdf: work/output work/reports/diabetes_classification_report.qmd
	quarto render work/reports/diabetes_classification_report.qmd --to pdf
