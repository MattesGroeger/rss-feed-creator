class Output
  include MongoMapper::Document

  timestamps!

  key :title,        String,  required: true
  key :description,  String,  required: true
  key :type,         String,  required: true, in: ['rss', 'json']
  key :config,       Object
  key :stream_ids,   Array
end
