#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

file = ARGV[0]
dataset = Dataset.from_csv_file file
model = Model::LazarRegression.create(training_dataset: dataset)

File.open("data/50cv.ids","w+") do |cvids|
  (0..49).each do |i|
    cv = Validation::RegressionCrossValidation.create model
    cvids.puts cv.id
  end
end
