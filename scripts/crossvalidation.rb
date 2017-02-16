#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox
require 'yaml'
name = File.basename ARGV[0], ".csv"
file = File.join "data",ARGV[0]
dataset = Dataset.from_csv_file file
model = Model::LazarRegression.create(training_dataset: dataset)#, algorithms: { :prediction => {:method => "Algorithm::Caret.rf"}, :similarity => { :min => 0.5 }})
id_file = File.join("data",ARGV[0].sub(/.csv/,"-cv-#{ARGV[1]}.id"))
cv = Validation::RegressionCrossValidation.create model
File.open(id_file,"w+"){|f| f.puts cv.id}
