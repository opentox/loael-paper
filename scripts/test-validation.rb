#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

test = Dataset.from_csv_file(File.join("data","test_log10.csv"))
train = Dataset.from_csv_file(File.join("data","training_log10.csv"))

model = Model::LazarRegression.create(training_dataset: train, algorithms: { :similarity => { :min => 0.3 }})
validation = Validation::TrainTest.create model, train, test
File.open(File.join("data","training-test-predictions.id","w+")) { |f| f.puts validation.id }
