# Paper
loael.pdf: loael.md functional-groups.pdf loael-dataset-correlation.pdf rmse.R test-set-validation.csv crossvalidations.R data/common-median.csv

loael.md: loael.Rmd rmse.R

loael.docx: loael.md functional-groups.pdf loael-dataset-correlation.pdf
	pandoc --filter pandoc-crossref --filter pandoc-citeproc loael.md -s -o loael.docx

rmse.R: rmse.rb
	ruby rmse.rb

crossvalidations.R: crossvalidations.rb
	ruby crossvalidations.rb

test-set-validation.csv: test-set-validation.rb
	ruby test-set-validation.rb

%.md: %.Rmd
	Rscript --vanilla -e "library(knitr); knit('$<');"

%.pdf: %.md
	pandoc --filter pandoc-crossref --filter pandoc-citeproc $< -s -o $@

functional-groups.pdf: functional-groups-reduced4R.csv functional-groups.R
	R CMD BATCH functional-groups.R

loael-dataset-correlation.pdf: loael-dataset-comparison.rb
	ruby loael-dataset-comparison.rb

#data/common-test.csv: create-test-set.rb
	#ruby create-test-set.rb

dataset-correlation.R: data/common-test.csv dataset-correlation.R
	Rscript dataset-correlation.R

# Validations

crossvalidation.R: data/mazzatorta.csv,data/swiss.csv,data/combined.csv crossvalidation.rb
	crossvalidation.rb

test-predictions: data/mazzatorta-test-predictions.csv data/swiss-test-predictions.csv data/combined-test-predictions.csv 

data/mazzatorta-test-predictions.csv: test-set-validation.rb data/test.csv data/mazzatorta.csv 
	ruby test-set-validation.rb mazzatorta.csv
data/swiss-test-predictions.csv: test-set-validation.rb data/test.csv data/swiss.csv
	ruby test-set-validation.rb swiss.csv
data/combined-test-predictions.csv: test-set-validation.rb data/test.csv data/combined.csv
	ruby test-set-validation.rb combined.csv

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
