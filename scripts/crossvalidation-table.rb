#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

id = File.open(ARGV[0]).readlines.sample.chomp # random cv
csv_file = "data/training_log10-cv.csv"
cv = Validation::RegressionCrossValidation.find id
data = []
cv.predictions.each do |cid,p|
  smi = Compound.find(cid).smiles
  warnings = "F"
  warnings = "T" if p["warnings"] and !p["warnings"].empty?
	if p["prediction_interval"]
		data << [smi,p["value"],p["measurements"].median,p["prediction_interval"][0],p["prediction_interval"][1],warnings]
	else
		data << [smi,p["value"],p["measurements"].median,nil,nil,warnings]
  end
end

data.sort!{|a,b| a[1] <=> b[1]}

CSV.open(csv_file,"w+") do |csv|
  csv << ["SMILES","LOAEL_measured_median","LOAEL_predicted","Prediction_interval_low","Prediction_interval_high","Warnings"]
  data.each{|r| csv << r}
end
