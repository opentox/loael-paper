require_relative 'include.rb'

name = File.basename ARGV[0], ".csv"
file = File.join DATA,ARGV[0]
dataset = Dataset.from_csv_file file
model = Model::LazarRegression.create(dataset, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_fingerprint_regression")
#model = Model::LazarRegression.create(dataset, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_physchem_regression")
#model = Model::LazarRegression.create(dataset, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_weighted_average")
csv_file = File.join(DATA,ARGV[0].sub(/.csv/,"-cv-#{ARGV[1]}.csv"))
id_file = File.join(DATA,ARGV[0].sub(/.csv/,"-cv-#{ARGV[1]}.id"))
cv = RegressionCrossValidation.create model
File.open(id_file,"w+"){|f| f.puts cv.id}

data = []
cv.predictions.each do |p|
  smi = Compound.find(p[0]).smiles
  data << [smi,p[1].median,p[2],p[3]]
end

data.sort!{|a,b| a[1] <=> b[1]}

CSV.open(csv_file,"w+") do |csv|
  csv << ["SMILES","LOAEL_measured_median","LOAEL_predicted","Confidence"]
  data.each{|r| csv << r}
end
