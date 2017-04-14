#!/usr/bin/env ruby
require_relative '../../lazar/lib/lazar'
include OpenTox

csv_in =  CSV.read(ARGV[0], :encoding => 'windows-1251:utf-8')
head = csv_in.shift
data = {}
csv_in.each do |line|
  c = Compound.from_smiles line[0]
  mmol = line[1].to_f
  data[c] ||= []
  data[c] << -Math.log10(c.mmol_to_mg(mmol)).signif(5)
end
File.open(File.join("data","mazzatorta_mg_dup.csv"),"w+") do |f|
  f.puts ["SMILES","LOAEL"].join ","
  data.each do |c,values|
    values.uniq!
    if values.size > 1
      values.each do |v|
        f.puts "#{c.smiles},#{v}"
      end
    end
  end
end
