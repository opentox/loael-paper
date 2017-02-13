#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

test = Dataset.from_csv_file(File.join("data","test_log10.csv"))
train = Dataset.from_csv_file(File.join("data","training_log10.csv"))

model = Model::LazarRegression.create(training_dataset: train)
validation = Validation::TrainTest.create model, train, test
puts validation.id
