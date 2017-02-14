#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox
require 'yaml'
name = File.basename ARGV[0], ".csv"
file = File.join "data",ARGV[0]
dataset = Dataset.from_csv_file file
#model = Model::LazarRegression.create(training_dataset: dataset)#, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_fingerprint_regression")
model = Model::LazarRegression.create(training_dataset: dataset, algorithms: { :similarity => { :min => 0.3 }})
csv_file = File.join("data",ARGV[0].sub(/.csv/,"-cv-#{ARGV[1]}.csv"))
id_file = File.join("data",ARGV[0].sub(/.csv/,"-cv-#{ARGV[1]}.id"))
cv = Validation::RegressionCrossValidation.create model
File.open(id_file,"w+"){|f| f.puts cv.id}
#cv = Validation::RegressionCrossValidation.first
p cv.id
data = []
cv.predictions.each do |cid,p|
  smi = Compound.find(cid).smiles
	if p["prediction_interval"]
		data << [smi,p["value"],p["measurements"].median,p["prediction_interval"][0],p["prediction_interval"][1]]
	else
		data << [smi,p["value"],p["measurements"].median,nil,nil]
  end
end

data.sort!{|a,b| a[1] <=> b[1]}

CSV.open(csv_file,"w+") do |csv|
  csv << ["SMILES","LOAEL_measured_median","LOAEL_predicted","Prediction_interval_low","Prediction_interval_high"]
  data.each{|r| csv << r}
end
=begin
=end
