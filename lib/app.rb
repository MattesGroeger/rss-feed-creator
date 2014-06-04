# encoding: utf-8

require 'sinatra'
require 'newrelic_rpm'
require 'mongo_mapper'
require_relative 'model/entry'
require_relative 'model/parser'
require_relative 'model/stream'
require_relative 'model/output'
require_relative 'model/website'
require_relative 'model/user'
require_relative 'renderer/rss'
require_relative 'renderer/json'

configure do
  mongo_db = ENV['DATABASE_URI'] || 'mongodb://localhost'
  MongoMapper.connection = Mongo::MongoClient.from_uri(mongo_db)
  MongoMapper.database = "rssfeed"
end

get '/output/:output_id' do |id|
  output(id)
end

def output(id)
  output = Output.find(BSON::ObjectId.from_string(id))
  if output.nil?
    halt 404, "Output for id '#{id}' not Found"
  end
  if output.type == 'rss'
    content_type 'text/xml; charset=utf-8'
    Renderer::rss(output)
  elsif output.type == 'json'
    content_type 'application/json; charset=utf-8'
    Renderer::json(output)
  else
    halt 500, "Unsupported output type '#{output.type}'"
  end
end
