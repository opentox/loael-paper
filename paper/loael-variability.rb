require_relative '../lazar/lib/lazar'
include OpenTox
#$mongo.database.drop
#$gridfs = $mongo.database.fs # recreate GridFS indexes
# compare duplicates within datasets
#old = Dataset.from_csv_file File.join(File.dirname(__FILE__),"regression","LOAEL_mmol_corrected_smiles.csv")
old = Dataset.from_csv_file File.join(File.dirname(__FILE__),"regression","LOAEL_mg_corrected_smiles_mmol.csv")
#new = Dataset.from_csv_file File.join(File.dirname(__FILE__),"regression","swissRat_chron_LOAEL.csv")
new = Dataset.from_csv_file File.join(File.dirname(__FILE__),"regression","swissRat_chron_LOAEL_mmol.csv")
#combined = Dataset.from_csv_file File.join(File.dirname(__FILE__),"regression","LOAEL-rat-combined.csv")

compound_vector = []
value_vector = []
dataset_vector = []

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
R.eval "df$smi <- reorder(df$factor.smi,df$values)"
R.eval "img <- ggplot(df, aes(smi,values,ymin = min(values), ymax=max(values),color=dataset))"
R.eval "img <- img + ylab('-log(LOAEL mg/kg_bw/day)') + xlab('Compound') + theme(axis.text.x = element_blank())"
R.eval "img <- img + geom_point()"
#R.eval "img <- img + scale_x_discrete(breaks=NULL) + geom_point() + coord_flip()"# + xlab('-log(LOAEL)'), ylab('Compound')"
#R.eval "ggsave(file='/home/ch/opentox/lazar-nestec-data/loael_variance.svg', plot=img)"
R.eval "ggsave(file='/home/ch/opentox/lazar-nestec-data/loael-variance.svg', plot=img,width=12, height=8)"
