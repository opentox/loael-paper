#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

validation = Validation::TrainTest.find File.read("data/training-test-predictions.id").chomp

data = []
puts ["SMILES","LOAEL_measured_median","LOAEL_predicted","Error","Dataset"].join(",")
validation.predictions.each do |id,p|
  data << [Compound.find(id).smiles, p["measurements"].median, p["value"], (p["measurements"].median-p["value"]).abs,"test-prediction"]
end

data.sort!{|a,b| a[1] <=> b[1]}
puts data.collect{|r| r.join ","}.join("\n")
