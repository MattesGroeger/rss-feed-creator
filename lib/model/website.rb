class Website
  include MongoMapper::Document

  key :key,   String, required: true, unique: true
  key :title, String, required: true
  key :url,   String

  timestamps!

  many :streams
end
