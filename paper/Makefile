# Paper
loael.pdf: loael.md references.bibtex
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -s -S --bibliography=references.bibtex --latex-engine=pdflatex --filter pandoc-crossref --filter pandoc-citeproc -o loael.pdf loael.md

loael.md: loael.Rmd figures validations
	Rscript --vanilla -e "library(knitr); knit('loael.Rmd');"

loael.docx: loael.md 
	pandoc --filter pandoc-crossref --filter pandoc-citeproc loael.md -s -o loael.docx

rmse.R: rmse.rb
	ruby rmse.rb

# Figures

figures: datasets validations figure/functional-groups.pdf  figure/test-prediction.pdf figure/test-correlation.pdf figure/crossvalidation.pdf

figure/functional-groups.pdf: data/functional-groups-reduced4R.csv functional-groups.R
	Rscript functional-groups.R

figure/crossvalidation.pdf: data/mazzatorta-cv.csv data/swiss-cv.csv data/combined-cv.csv 
	Rscript crossvalidation-plots.R

figure/test-prediction.pdf: data/mazzatorta-test-predictions.csv data/swiss-test-predictions.csv data/combined-test-predictions.csv data/median-correlation.csv  test-prediction-plot.R
	Rscript test-prediction-plot.R

figure/test-correlation.pdf: data/mazzatorta-test-predictions.csv data/swiss-test-predictions.csv data/combined-test-predictions.csv data/median-correlation.csv  test-correlation-plot.R
	Rscript test-correlation-plot.R

# Validations

validations: test-predictions crossvalidations

crossvalidations: data/mazzatorta-cv.csv data/swiss-cv.csv data/combined-cv.csv

data/mazzatorta-cv.csv: crossvalidation.rb data/mazzatorta.csv
	ruby crossvalidation.rb mazzatorta.csv

data/swiss-cv.csv: crossvalidation.rb data/swiss.csv
	ruby crossvalidation.rb swiss.csv

data/combined-cv.csv: crossvalidation.rb data/combined.csv
	ruby crossvalidation.rb combined.csv

test-predictions: data/mazzatorta-test-predictions.csv data/swiss-test-predictions.csv data/combined-test-predictions.csv 

data/mazzatorta-test-predictions.csv: test-validation.rb data/test.csv data/mazzatorta.csv 
	ruby test-validation.rb mazzatorta.csv
data/swiss-test-predictions.csv: test-validation.rb data/test.csv data/swiss.csv
	ruby test-validation.rb swiss.csv
data/combined-test-predictions.csv: test-validation.rb data/test.csv data/combined.csv
	ruby test-validation.rb combined.csv

# Datasets

datasets: data/median-correlation.csv data/test.csv data/combined.csv data/mazzatorta.csv data/swiss.csv

# Medians for dataset correlation
data/median-correlation.csv: create-median-correlation.rb data/mazzatorta.csv data/swiss.csv
	ruby create-median-correlation.rb

# Test set
data/test.csv: create-test.rb data/mazzatorta.csv data/swiss.csv
	ruby create-test.rb

# Combined training set
data/combined.csv: create-combined.rb data/mazzatorta.csv data/swiss.csv
	ruby create-combined.rb

# Datasets with unique smiles
data/mazzatorta.csv: unique-smiles.rb data/LOAEL_mg_corrected_smiles_mmol.csv 
	ruby unique-smiles.rb data/LOAEL_mg_corrected_smiles_mmol.csv "mazzatorta"

data/swiss.csv: unique-smiles.rb data/swissRat_chron_LOAEL_mmol.csv
	ruby unique-smiles.rb data/swissRat_chron_LOAEL_mmol.csv "swiss"
