#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox
csv_in =  CSV.read(ARGV[0], :encoding => 'windows-1251:utf-8')
head = csv_in.shift
data = []
csv_in.each do |line|
  smi = line[11]
  mg = line[19]
  unless mg.to_f == 0.0
    c = Compound.from_smiles smi
    # round to 5 significant digits in order to detect duplicates 
    mmol = c.mg_to_mmol(mg.to_f).signif(5)
    data << [c.smiles, mmol,"swiss"]
  end
end
data.sort!{|a,b| a[1] <=> b[1]}
File.open(File.join("data","swiss.csv","w+")) do |f|
  f.puts ["SMILES","LOAEL","Dataset"].join ","
  f.puts data.collect{|row| row.join ","}.join "\n"
end
