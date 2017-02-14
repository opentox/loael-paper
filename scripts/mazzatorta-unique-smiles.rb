#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

csv_in =  CSV.read(ARGV[0], :encoding => 'windows-1251:utf-8')
head = csv_in.shift
data = []
data = []
csv_in.each do |line|
  c = Compound.from_smiles line[0]
  # round to 5 significant digits in order to detect duplicates 
  mmol = line[1].to_f.signif(5)
  data << [c.smiles,mmol,"mazzatorta"] #if c
end
data.sort!{|a,b| a[1] <=> b[1]}
File.open(File.join("data","mazzatorta.csv","w+")) do |f|
  f.puts ["SMILES","LOAEL","Dataset"].join ","
  f.puts data.collect{|row| row.join ","}.join "\n"
end
