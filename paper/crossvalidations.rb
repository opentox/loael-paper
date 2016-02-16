require_relative 'include.rb'
file = File.join(DATA,ARGV[0])
dataset = Dataset.from_csv_file file
model = Model::LazarRegression.create dataset
cv = RegressionCrossValidation.create model
=begin
=end

datasets = ["mazzatorta","swiss","combined"]
File.open("crossvalidations.R","w+") do |f|
  [0,1,5].each do |i|
    dataset = datasets.shift
    cv = OpenTox::RegressionCrossValidation.all[i]
    f.puts "cv.#{dataset}.rmse <- #{cv.rmse}"
    f.puts "cv.#{dataset}.r.squared <- #{cv.r_squared}"
    f.puts "cv.#{dataset}.mae <- #{cv.mae}"
  end
end
