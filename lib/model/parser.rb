class Parser
  include MongoMapper::Document

  timestamps!

  key :file,  String, required: true
  key :clazz, String, required: true
end
