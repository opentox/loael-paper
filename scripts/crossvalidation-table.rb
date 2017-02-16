#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox
require 'yaml'
csv_file = ARGV[0].sub(/id$/,"csv")
cv = Validation::RegressionCrossValidation.find File.read(ARGV[0]).chomp
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
