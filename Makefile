# Variables

datasets = data/median-correlation.csv data/test_log10.csv data/training_log10.csv data/mazzatorta_log10.csv data/swiss_log10.csv data/swiss_mg_dup.csv data/mazzatorta_mg_dup.csv data/all_mg_dup.csv
validations = data/training-test-predictions.csv data/50cv.csv data/misclassifications.csv
figures = figures/functional-groups.pdf  figures/test-prediction.pdf figures/prediction-test-correlation.pdf figures/dataset-variability.pdf figures/median-correlation.pdf figures/crossvalidation.pdf

# Paper
loael.pdf: loael.tex
	pdflatex loael.tex; pdflatex loael.tex

loael.tex: loael.md references.bibtex
	pandoc -s --bibliography=references.bibtex --filter pandoc-crossref --filter pandoc-citeproc -o loael.tex loael.md

loael.md: loael.Rmd $(figures) $(datasets) $(validations) 
	export LANG=en_US.UTF-8; Rscript --vanilla -e "library(knitr); knit('loael.Rmd');"

loael.docx: loael.md 
	pandoc -s --bibliography=references.bibtex --latex-engine=pdflatex --filter pandoc-crossref --filter pandoc-citeproc -o loael.docx loael.md

loael.txt: loael.md 
	pandoc -s --bibliography=references.bibtex --latex-engine=pdflatex --filter pandoc-crossref --filter pandoc-citeproc -o loael.txt loael.md

# Figures

figures/functional-groups.pdf: data/functional-groups-reduced4R.csv
	scripts/functional-groups.R

figures/dataset-variability.pdf: data/test_log10_database_fix.csv
	scripts/dataset-variability.R

figures/test-prediction.pdf: data/predictions-measurements.csv
	scripts/test-prediction-plot.R

figures/prediction-test-correlation.pdf: data/training-test-predictions.csv
	scripts/prediction-test-correlation-plot.R

figures/median-correlation.pdf: data/median-correlation.csv
	scripts/median-correlation-plot.R

figures/crossvalidation.pdf: data/training_log10-cv.csv
	scripts/crossvalidation-plots.R 

# Validations

data/predictions-measurements.csv: data/training-test-predictions.csv data/test_log10.csv
	scripts/test-prediction.rb

data/misclassifications.csv: data/training-test-predictions.csv
	scripts/misclassifications.rb

data/training-test-predictions.csv: data/training-test-predictions.id
	scripts/test-validation-results.rb 

data/training-test-predictions.id: data/test_log10.csv data/training_log10.csv
	scripts/testset-validation.rb

data/training_log10-cv.csv: data/50cv.ids
	scripts/crossvalidation-table.rb data/50cv.ids

data/50cv.csv: data/50cv.ids
	scripts/50cv-table.rb data/50cv.ids

data/50cv.ids: data/training_log10.csv
	scripts/50-crossvalidations.rb data/training_log10.csv

# Datasets

# Functional groups
data/functional-groups-reduced4R.csv: data/functional-groups-reduced.csv 
	scripts/functional-groups4R.rb

# Medians for dataset correlation
data/median-correlation.csv: data/mazzatorta_log10.csv data/swiss_log10.csv
	scripts/create-median-correlation.rb

# Test set
data/test_log10.csv: data/mazzatorta_log10.csv data/swiss_log10.csv
	scripts/create-testset.rb 

data/test_log10_database_fix.csv: data/test_log10.csv
	sed 's/mazzatorta/Nestle/' data/test_log10.csv | sed 's/mazzatorta and swiss/Both/' | sed 's/swiss/FSVO/' > data/test_log10_database_fix.csv

# Training set
data/training_log10.csv: data/mazzatorta_log10.csv data/swiss_log10.csv
	scripts/create-trainingset.rb

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

data/mazzatorta_mg_dup.csv: data/LOAEL_mg_corrected_smiles_mmol.csv 
	scripts/mazzatorta_mg_dup.rb data/LOAEL_mg_corrected_smiles_mmol.csv

data/swiss.csv: data/NOAEL-LOAEL_SMILES_rat_chron.csv
	scripts/noael_loael2mmol.rb data/NOAEL-LOAEL_SMILES_rat_chron.csv

data/swiss_mg_dup.csv: data/NOAEL-LOAEL_SMILES_rat_chron.csv
	scripts/noael_loael2swiss_mg_dup.rb data/NOAEL-LOAEL_SMILES_rat_chron.csv

data/all_mg_dup.csv: data/NOAEL-LOAEL_SMILES_rat_chron.csv data/LOAEL_mg_corrected_smiles_mmol.csv 
	scripts/all_mg_dup.rb

clean:
	rm figures/*pdf
	cd data && rm `ls -I "*LOAEL*" -I "*functional*" -I "*SMARTS*"`
	mongo production --eval "db.dropDatabase()"
