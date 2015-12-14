require_relative '../lazar/lib/lazar'
include OpenTox
#$mongo.database.drop
#$gridfs = $mongo.database.fs # recreate GridFS indexes
# compare duplicates within datasets
old = Dataset.from_csv_file File.join(File.dirname(__FILE__),"regression","LOAEL_mmol_corrected_smiles.csv")
new = Dataset.from_csv_file File.join(File.dirname(__FILE__),"regression","swissRat_chron_LOAEL.csv")

combined_compounds = old.compound_ids & new.compound_ids

compound_vector = []
value_vector = []
dataset_vector = []

combined_compounds.each do |cid|
  c = Compound.find cid
  old.values(c,old.features.first).each do |v|
    compound_vector << c.smiles
    value_vector << -Math.log(v)
    dataset_vector << old.name
  end
  new.values(c,new.features.first).each do |v|
    compound_vector << c.smiles
    value_vector << -Math.log(v)
    dataset_vector << new.name
  end
end

R.assign "smi", compound_vector
R.assign "values", value_vector
R.assign "dataset", dataset_vector
R.eval "df <- data.frame(factor(smi),values,factor(dataset))"
R.eval "img <- ggplot(df, aes(smi,values,ymin = min(values), ymax=max(values),color=dataset))"
R.eval "img <- img + scale_x_discrete(breaks=NULL) + geom_point() + coord_flip() + ylab('-log(LOAEL)') + xlab('Compound')"
R.eval "ggsave(file='/home/ch/opentox/lazar-nestec-data/loael-dataset-comparison.svg', plot=img)"

=begin

vars = []

[old, new].each do |dataset|
  vars << []
  #vars[dataset.name] = []
  p dataset.name
  p dataset.compounds.size
  p dataset.duplicates(dataset.features.first).size
  dataset.duplicates.each do |cid,values|
    R.assign "values", values
    var = R.eval("var(-log(values))").to_f
    vars.last << var
    #smi = Compound.find(cid).smiles
    smi = cid.to_s
    values.each do |val|
      compound_vector << smi
      value_vector << - Math.log(val)
      dataset_vector << dataset.name
    end
    #vars << { :var => var, :values => values, :smiles => smi }
  end
  #vars.sort!{|a,b| a[:var] <=> b[:var]}
  #vars.each do |dup|
    #dup[:values].each do |v|
      #compound_vector << dup[:smiles]
      #value_vector << v
    #end
  #end
end
#p vars
# TODO statistical test for variances
R.assign "vars1", vars[0]
R.assign "vars2", vars[1]
print "p-value: #{R.eval("t.test(vars1,vars2)$p.value").to_f}"

R.assign "smi", compound_vector
R.assign "values", value_vector
R.assign "dataset", dataset_vector
R.eval "df <- data.frame(factor(smi),values,factor(dataset))"
R.eval "img <- ggplot(df, aes(smi,values,ymin = min(values), ymax=max(values),color=dataset))"
R.eval "img <- img + scale_x_discrete(breaks=NULL) + geom_point() + coord_flip()"# + xlab('-log(LOAEL)'), ylab('Compound')"
R.eval "ggsave(file='/home/ch/opentox/lazar-nestec-data/loael_variance.svg', plot=img)"
#R.eval "print(img)"
#R.eval "write.csv(df,'/home/ch/opentox/lazar-nestec-data/loael.csv')"
#`inkview /home/ch/opentox/lazar-nestec-data/loael_variance.svg`
#R.eval "ggsave(file='test.svg', plot=img)"
# compare datasets
# compare combined datasets
file = File.join(File.dirname(__FILE__),"regression","LOAEL-rat-combined.csv")
d = Dataset.from_csv_file file
replicates = []
compounds = d.compound_ids.uniq
sds = []
compounds.each do |cid|
  compound_idxs = d.compound_ids.each_index.select{|i| d.compound_ids[i] == cid}
  if compound_idxs.size > 1
    vals =  compound_idxs.collect{|i| d.data_entries[i].first }
    R.assign "values", vals
    #sd = R.eval("sd(-log(values))").to_f
    sd = R.eval("var(values)").to_f
    sds << { :sd => sd, :values => vals, :smiles => Compound.find(cid).smiles }
    #replicates <<  compound_idxs.collect{|i| d.data_entries[i].first }
    #replicates[Compound.find(cid).smiles] = compound_idxs.collect{|i| d.data_entries[i].first }
  end
end
p sds.sort{|a,b| a[:sd] <=> b[:sd]}
#R.assign "replicates", replicates
#R.assign "compounds", compounds.collect{|id| Compound.find id }
#R.eval "df = data.frame(compounds,replicates)"
#library(ggplot2)
#qplot(compounds, replicates, data=df, geom="boxplot")
#p replicates.to_json
#p replicates.size
# http://www.unc.edu/courses/2008spring/psyc/270/001/variance.html
=end
