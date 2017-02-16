#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

predictions = {}
warnings = {}
CSV.foreach("data/training-test-predictions.csv") do |row|
  unless row[0] == "SMILES"
    predictions[row[0]] = row[2]
    warnings[row[0]] = row[5]
  end
end

measurements = {}
CSV.foreach("data/test_log10.csv") do |row|
  unless row[0] == "SMILES"
    measurements[row[0]] ||= []
    measurements[row[0]] << row[1]
  end
end

File.open(File.join("data","predictions-measurements.csv"),"w+") do |f|
  f.puts ["SMILES","LOAEL","Origin"].join ","
  predictions.each do |smi,v|
    if warnings[smi] == "T"
      f.puts [smi,v,"Warning"].join ","
    elsif warnings[smi] == "F"
      f.puts [smi,v,"Prediction"].join ","
    end
    measurements[smi].each do |m|
      f.puts [smi,m,"Measurement"].join ","
    end
  end
end

