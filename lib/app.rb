# encoding: utf-8

require 'sinatra'
require 'newrelic_rpm'
require 'mongo_mapper'
require_relative 'model/entry'
require_relative 'model/parser'
require_relative 'model/stream'
require_relative 'model/output'
require_relative 'model/website'
require_relative 'fetcher/fetch'
require_relative 'fetcher/http'
require_relative 'renderer/rss'

configure do
  mongo_db = ENV['DATABASE_URI'] || 'mongodb://localhost'
  MongoMapper.connection = Mongo::MongoClient.from_uri(mongo_db)
  MongoMapper.database = "rssfeed"
end

get '/output/:output_id' do |id|
  update()
  output(id)
end

# @deprecated
get '/rss.xml' do
  migrate() # Run migrations
  update()  # Retrieve new contents
  output(Output.first._id.to_s) # Legacy
end

def migrate
  if Website.all.count > 0
    return
  end

  w = Website.new(key: "ard-mediathek",
                  title: "ARD Mediathek",
                  url: "http://www.ardmediathek.de")

  Parser.destroy_all
  p = Parser.create(file: "mediathek_parser",
                    clazz: "MediathekParser")

  w.streams << Stream.new(key: "doku-reportage",
                          title: "Doku & Reportage",
                          url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html",
                          details_url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{uid}}/view=ajax/isFromList=true/index.html",
                          max_details: 5,
                          parser_id: p._id)

  MongoMapper.database
    .collection("items")
    .find.sort([["discovered", 1]])
    .to_a.each { |item|
      Entry.create(
        uid: item["id"],
        title: item["title"],
        description: item["description"],
        url: item["url"],
        image_url: item["image_url"],
        stream_id: w.streams.first._id,
        data: {
          show: item["show"],
          channel: item["channel"],
          duration: item["duration"],
          date: item["date"],
          rating: item["rating"]
        }
      )
  }

  w.save

  Output.destroy_all
  Output.create(
    title: 'Mediathek Doku Feed',
    description: 'Neuste ARD Mediathek Reportage & Doku Beiträge',
    type: 'rss',
    config: {
      file: 'mediathek_formatter_rss',
      class: 'MediathekFormatterRss',
      item_count: 25
    },
    stream_ids: [w.streams.first._id]
  )
end

def update
  Website.all.each { |website|
    website.streams.each { |stream|
      Fetcher::fetch(stream, Http.new)
    }
  }
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
    {}.to_json # todo
  else
    halt 500, "Unsupported output type '#{output.type}'"
  end
end
