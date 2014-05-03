class Entry
  include MongoMapper::Document

  timestamps!

  key :uid,          String,  required: true, unique: true
  key :title,        String
  key :description,  String
  key :url,          String
  key :image_url,    String
  key :data,         Object

  key :seen,         Boolean, default: false

  belongs_to :stream
end
