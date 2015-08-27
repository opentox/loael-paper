require_relative '../lazar/lib/lazar'
include OpenTox
#$logger.level = Logger::DEBUG
#Mongo::Logger.level = Logger::WARN 
$mongo.database.drop
$gridfs = $mongo.database.fs # recreate GridFS indexes

classification_input = Dir["classification/*csv"]

classification_input.each do |file|
  p file
  unless file.match("hamster")
  #unless file.match("kazius")
    p "Parsing #{file}"
    metadata = JSON.parse(File.read(file.sub(/csv$/,"json")))
    p metadata
    pm = Model::PredictionModel.new(metadata)
    p pm.class
    p pm
      
    p "Parsing #{file}"
    training_dataset = Dataset.from_csv_file file
    p "Creating model for #{file}"
    model = Model::LazarFminerClassification.create training_dataset
    p "Creating crossvalidation for #{file}"
    cv = ClassificationCrossValidation.create model
    pm[:model_id] = model.id
    pm[:crossvalidation_id] = cv.id
    p pm
    p pm.save
  end
end

`mongodump`
