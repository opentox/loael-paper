#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox
csv_in =  CSV.read("data/NOAEL-LOAEL_SMILES_rat_chron.csv", :encoding => 'windows-1251:utf-8')
head = csv_in.shift
data = {}
csv_in.each do |line|
  smi = line[11]
  mg = line[19].to_f
  unless mg.to_f == 0.0
    c = Compound.from_smiles smi
    data[c.smiles] ||= []
    data[c.smiles] << -Math.log10(mg).signif(5)
  end
end
csv_in =  CSV.read("data/LOAEL_mg_corrected_smiles_mmol.csv", :encoding => 'windows-1251:utf-8')
head = csv_in.shift
data = {}
csv_in.each do |line|
  c = Compound.from_smiles line[0]
  mmol = line[1].to_f
  data[c.smiles] ||= []
  data[c.smiles] << -Math.log10(c.mmol_to_mg(mmol)).signif(5)
end
File.open(File.join("data","all_mg_dup.csv"),"w+") do |f|
  f.puts ["SMILES","LOAEL"].join ","
  data.each do |smi,values|
    values.uniq!
    if values.size > 1
      values.each do |v|
        f.puts "#{smi},#{v}"
      end
    end
  end
end
