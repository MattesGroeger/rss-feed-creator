class Entry
  include MongoMapper::Document

  key :guid, String
  key :user, Object
  key :parser, Object
  key :data, Object
end
