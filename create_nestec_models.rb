require_relative '../lazar/lib/lazar'
include OpenTox
$mongo.database.drop
$gridfs = $mongo.database.fs # recreate GridFS indexes

["Rat_TD50.csv","Mouse_TD50.csv"].each do |file|
  file = File.join(File.dirname(__FILE__),"regression",file)
  Model::Prediction.from_csv_file file
end
#`mongodump`
