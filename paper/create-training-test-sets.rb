require_relative '../../lazar/lib/lazar'
include OpenTox
dirpath = File.join(File.dirname(__FILE__),"..","regression")
old = CSV.read File.join(dirpath,"LOAEL_mg_corrected_smiles_mmol.csv")
old.shift
new = CSV.read File.join(dirpath,"swissRat_chron_LOAEL_mmol.csv")
new.shift
p old.size
p new.size
# canonical smiles
old.collect!{|r| [Compound.from_smiles(r.first).smiles, r.last]}
new.collect!{|r| [Compound.from_smiles(r.first).smiles, r.last]}
old_compounds = old.collect{|r| r.first}.uniq
new_compounds = new.collect{|r| r.first}.uniq
p old_compounds.size
p new_compounds.size
common_compounds = (old_compounds & new_compounds).uniq
p common_compounds.size
common = []
# TODO: canonical smiles??
common_compounds.each do |smi|
  old_rows = old.select{|r| r.first == smi}
  new_rows = new.select{|r| r.first == smi}
  common += old_rows + new_rows
  old -= old_rows
  new -= new_rows
end
header = ["SMILES","LOAEL"]
p old.size
p new.size
p common.size
{
  "mazzatorta-loael-training.csv" => old.uniq,
  "swiss-loael-training.csv" => new.uniq,
  "combined-training.csv" => (old+new).uniq,
  "common-test.csv" => common.uniq,
}.each do |file,data|
  CSV.open(File.join(dirpath,file),"w+") do |csv|
    csv << header
    data.each{|row| csv << row}
  end
end
