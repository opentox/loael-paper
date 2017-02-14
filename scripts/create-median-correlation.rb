#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

old = Dataset.from_csv_file File.join("data","mazzatorta_log10.csv")
new = Dataset.from_csv_file File.join("data","swiss_log10.csv")

common_compounds = (old.compounds & new.compounds).uniq

data = []
common_compounds.each do |c|
  old_values = old.values(c,old.features.first)
  new_values = new.values(c,new.features.first)
  identical = old_values & new_values
  unless identical.empty?
    old_values -= identical
    new_values -= identical
  end
  unless old_values.empty? or new_values.empty?
    data << [c.smiles,old_values.median,new_values.median]
  end
end

data.sort!{|a,b| a[1] <=> b[1]}
File.open(File.join("data","median-correlation.csv","w+")) do |f|
  f.puts ["SMILES","mazzatorta","swiss"].join(",")
  f.puts data.collect{|r| r.join ","}.join("\n")
end
