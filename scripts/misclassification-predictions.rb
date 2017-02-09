require_relative "include.rb"
dataset = Dataset.from_csv_file "data/training.csv"
compounds = CSV.read("data/misclassifications.csv")[1..2].collect{|m| Compound.from_smiles(m[0])}
model = Model::LazarRegression.create(dataset, :prediction_algorithm => "OpenTox::Algorithm::Regression.local_fingerprint_regression")
#predictions = compounds.collect{|c| model.predict c}
#predictions.each do |p|
#end
#p compounds[1].smiles
p compounds[1].names
prediction = model.predict compounds[1]
#prediction[:neighbors] = prediction[:neighbors].collect{|n| n.delete(:dataset_ids)}
prediction[:neighbors].each{|n| n.delete(:dataset_ids)}
#prediction[:neighbors] = prediction[:neighbors].collect{|n| n[:tanimoto]}
prediction[:neighbors] = prediction[:neighbors].collect{|n| Compound.find(n["_id"]).smiles}
puts JSON.pretty_generate(prediction)
