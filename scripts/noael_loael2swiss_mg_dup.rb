#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox
csv_in =  CSV.read(ARGV[0], :encoding => 'windows-1251:utf-8')
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
File.open(File.join("data","swiss_mg_dup.csv"),"w+") do |f|
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
