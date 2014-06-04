class Parser
  include MongoMapper::Document

  key :user, Object
  key :url, String
  key :title, String
  key :loopElement, String
  key :index, String
end
