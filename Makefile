# Paper

loael.pdf: loael.md references.bibtex
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -s -S --bibliography=references.bibtex --latex-engine=pdflatex --filter pandoc-crossref --filter pandoc-citeproc -o loael.pdf loael.md

loael.md: loael.Rmd figures # TODO: add further dependencies
	Rscript --vanilla -e "library(knitr); knit('loael.Rmd');"

loael.docx: loael.md 
	pandoc --filter pandoc-crossref --filter pandoc-citeproc loael.md -s -o loael.docx

# Figures

figures: datasets validations figure/functional-groups.pdf  figure/test-prediction.pdf figure/test-correlation.pdf figure/crossvalidation.pdf figure/dataset-variability.pdf

figure/functional-groups.pdf: data/functional-groups-reduced4R.csv functional-groups.R
	Rscript functional-groups.R
figure/dataset-variability.pdf: data/mazzatorta.csv data/swiss.csv dataset-variability.R
	Rscript dataset-variability.R

figure/crossvalidation.pdf: data/combined-cv.csv 
	Rscript crossvalidation-plots.R

figure/test-prediction.pdf: data/combined-test-predictions.csv data/median-correlation.csv  test-prediction-plot.R
	Rscript test-prediction-plot.R

figure/test-correlation.pdf: data/combined-test-predictions.csv data/median-correlation.csv  test-correlation-plot.R
	Rscript test-correlation-plot.R

# Validations

validations: data/combined-cv.csv data/combined-test-predictions.csv

data/combined-cv.csv: crossvalidation.rb data/combined.csv
	ruby crossvalidation.rb combined.csv

data/combined-test-predictions.csv: test-validation.rb data/test.csv data/combined.csv
	ruby test-validation.rb combined.csv

# Datasets

datasets: data/median-correlation.csv data/test.csv data/combined.csv data/mazzatorta.csv data/swiss.csv data/test.json data/combined.json data/mazzatorta.json data/swiss.json

# Medians for dataset correlation
data/median-correlation.csv: create-median-correlation.rb data/mazzatorta.csv data/swiss.csv
	ruby create-median-correlation.rb

# Test set
data/test.csv: create-test.rb data/mazzatorta.csv data/swiss.csv
	ruby create-test.rb

data/test.json: data/mazzatorta.json 
	cp data/mazzatorta.json data/test.json

# Combined training set
data/combined.csv: create-combined.rb data/mazzatorta.csv data/swiss.csv
	ruby create-combined.rb

data/combined.json: data/mazzatorta.json 
	cp data/mazzatorta.json data/combined.json

# Datasets with unique smiles
data/mazzatorta.csv: unique-smiles.rb data/LOAEL_mg_corrected_smiles_mmol.csv 
	ruby unique-smiles.rb data/LOAEL_mg_corrected_smiles_mmol.csv "mazzatorta"

data/mazzatorta.json: data/LOAEL_mg_corrected_smiles_mmol.json 
	cp data/LOAEL_mg_corrected_smiles_mmol.json data/mazzatorta.json

data/swiss.csv: unique-smiles.rb data/swissRat_chron_LOAEL_mmol.csv
	ruby unique-smiles.rb data/swissRat_chron_LOAEL_mmol.csv "swiss"

data/swiss.json: data/swissRat_chron_LOAEL_mmol.json
	cp data/swissRat_chron_LOAEL_mmol.json data/swiss.json

clean:
	cd data && rm `ls -I "*LOAEL*" -I "*functional*" -I "*SMARTS*"`
