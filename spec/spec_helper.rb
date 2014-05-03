require 'require_all'
require_rel('../lib')

require 'mongo_mapper'


MongoMapper.connection = Mongo::MongoClient.from_uri('mongodb://localhost')
MongoMapper.database = "test"
MongoMapper.database.collections.each { |c| c.drop_indexes }

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :without_connection) do |example|
    old, MongoMapper.connection = MongoMapper.connection, nil
    example.run
    MongoMapper.connection = old
  end
end
