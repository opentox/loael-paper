loael.pdf: loael.md functional-groups.pdf loael-dataset-correlation.pdf
	pandoc --filter pandoc-citeproc loael.md -s -o loael.pdf

loael.docx: loael.md functional-groups.pdf loael-dataset-correlation.pdf
	pandoc --filter pandoc-citeproc loael.md -s -o loael.docx

%.md: %.Rmd
	Rscript --vanilla -e "library(knitr); knit('$<');"

%.pdf: %.md
	pandoc --filter pandoc-citeproc $< -s -o $@

functional-groups.pdf: functional-groups-reduced4R.csv functional-groups.R
	R CMD BATCH functional-groups.R

loael-dataset-correlation.pdf: loael-dataset-comparison.rb
	ruby loael-dataset-comparison.rb
