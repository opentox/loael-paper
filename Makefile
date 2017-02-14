# Variables

datasets = data/median-correlation.csv data/test_log10.csv data/training_log10.csv data/mazzatorta_log10.csv data/swiss_log10.csv 
crossvalidations = data/training_log10-cv-0.csv data/training_log10-cv-1.csv data/training_log10-cv-2.csv
validations = data/training-test-predictions.csv $(crossvalidations) data/misclassifications.csv
figures = figures/functional-groups.pdf  figures/test-prediction.pdf figures/test-correlation.pdf figures/crossvalidation.pdf figures/dataset-variability.pdf

# Paper

loael.pdf: loael.md references.bibtex
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -s -S --bibliography=references.bibtex --latex-engine=pdflatex --filter pandoc-crossref --filter pandoc-citeproc -o loael.pdf loael.md

loael.md: loael.Rmd $(figures) $(datasets) $(validations) 
	Rscript --vanilla -e "library(knitr); knit('loael.Rmd');"

loael.docx: loael.md 
	pandoc --filter pandoc-crossref --filter pandoc-citeproc loael.md -s -o loael.docx

# Figures

figures/functional-groups.pdf: data/functional-groups-reduced4R.csv
	scripts/functional-groups.R

figures/dataset-variability.pdf: data/mazzatorta_log10.csv data/swiss_log10.csv
	scripts/dataset-variability.R

figures/crossvalidation.pdf: $(crossvalidations)
	scripts/crossvalidation-plots.R

figures/test-prediction.pdf: data/predictions-measurements.csv
	scripts/test-prediction-plot.R

figures/test-correlation.pdf: data/training-test-predictions.csv data/median-correlation.csv
	scripts/test-correlation-plot.R

# Validations

data/predictions-measurements.csv: data/training-test-predictions.csv data/test_log10.csv
	scripts/test-prediction.rb

data/misclassifications.csv: data/training-test-predictions.csv
	scripts/misclassifications.rb

data/training-test-predictions.csv: data/training-test-predictions.id
	scripts/test-validation-results.rb 

data/training-test-predictions.id: data/test_log10.csv data/training_log10.csv
	scripts/test-validation.rb

data/training_log10-cv-0.csv: data/training_log10.csv
	scripts/crossvalidation.rb training_log10.csv 0

data/training_log10-cv-1.csv: data/training_log10.csv
	scripts/crossvalidation.rb training_log10.csv 1

data/training_log10-cv-2.csv: data/training_log10.csv
	scripts/crossvalidation.rb training_log10.csv 2

# Datasets

data/functional-groups-reduced4R.csv: data/functional-groups-reduced.csv 
	scripts/functional-groups4R.rb

# Medians for dataset correlation
data/median-correlation.csv: data/mazzatorta_log10.csv data/swiss_log10.csv
	scripts/create-median-correlation.rb

# Test set
data/test_log10.csv: data/mazzatorta_log10.csv data/swiss_log10.csv
	scripts/create-test.rb 

#data/test.json: data/mazzatorta.json 
	#cp data/mazzatorta.json data/test.json

# Combined training set
data/training_log10.csv: data/mazzatorta_log10.csv data/swiss_log10.csv
	scripts/create-training.rb

#data/training.json: data/mazzatorta.json 
	#cp data/mazzatorta.json data/training.json

# -log10 transformations
data/mazzatorta_log10.csv: data/mazzatorta.csv
	../lazar/scripts/mmol2-log10.rb data/mazzatorta.csv
	sed -i 's/-log10(LOAEL)/LOAEL/' data/mazzatorta_log10.csv # R cannot parse -log10(LOAEL) header

data/swiss_log10.csv: data/swiss.csv
	../lazar/scripts/mmol2-log10.rb data/swiss.csv
	sed -i 's/-log10(LOAEL)/LOAEL/' data/swiss_log10.csv # R cannot parse -log10(LOAEL) header

# Datasets with unique smiles
data/mazzatorta.csv: data/LOAEL_mg_corrected_smiles_mmol.csv 
	scripts/mazzatorta-unique-smiles.rb data/LOAEL_mg_corrected_smiles_mmol.csv

data/swiss.csv: data/NOAEL-LOAEL_SMILES_rat_chron.csv
	scripts/noael_loael2mmol.rb data/NOAEL-LOAEL_SMILES_rat_chron.csv

clean:
	rm figures/*pdf
	cd data && rm `ls -I "*LOAEL*" -I "*functional*" -I "*SMARTS*"`
	mongo production --eval "db.dropDatabase()"
