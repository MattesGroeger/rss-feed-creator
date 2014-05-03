# encoding: utf-8

require 'sinatra'
require 'newrelic_rpm'
require 'mongo_mapper'
require_relative 'model/entry'
require_relative 'model/parser'
require_relative 'model/stream'
require_relative 'model/website'
require_relative 'fetcher/http'
require_relative 'update'
require_relative 'rss'

WATCHES = {
  ard: {
    info: {
      title: 'ARD Mediathek Reportage & Doku',
      description: 'ARD Mediathek Reportage & Doku',
      link: 'http://www.ardmediathek.de/fernsehen',
      language: 'de'
    },
    # url: 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html',
    # details_url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{id}}/view=ajax/isFromList=true/index.html",
    # max_details: 5,
    # parser: {file: 'mediathek', class: 'ARDMediathekParser'},
    formatter: {file: 'mediathek_rss', class: 'ARDMediathekFeedFormatter'}
  }
}

configure do
  mongo_db = ENV['DATABASE_URI'] || 'mongodb://localhost'
  MongoMapper.connection = Mongo::MongoClient.from_uri(mongo_db)
  MongoMapper.database = "rssfeed"
end

get '/rss.xml' do
  content_type 'text/xml; charset=utf-8'

  # Run migrations
  migrate()

  # Retrieve new contents
  Website.all.each { |website|
    website.streams.each { |stream|
      Feed::update(stream, Http.new)
    }
  }

  # Render rss feed - todo get rid of it here
  Feed::rss(WATCHES[:ard])
end

def migrate
  if Website.all.count > 0
    return
  end

  w = Website.new(key: "ard-mediathek",
                  title: "ARD Mediathek",
                  url: "http://www.ardmediathek.de")

  p = Parser.create(file: "mediathek",
                    clazz: "ARDMediathekParser")

  w.streams << Stream.new(key: "doku-reportage",
                          title: "Doku & Reportage",
                          url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html",
                          details_url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{uid}}/view=ajax/isFromList=true/index.html",
                          max_details: 5,
                          parser_id: p._id)

  w.save
end
