require 'sinatra'
require 'rss'
require 'mongo'
require_relative 'parser'
require_relative 'feed'

MAX_ENTRIES = 300
ITEMS_TO_LOAD_AT_ONCE = 10

#MONGO = Mongo::Connection.new.db("rss")
MONGO = Mongo::MongoClient.from_uri("mongodb://root:K8VhcEzQVbgc3z@ds047458.mongolab.com:47458/rssfeed").db("rssfeed")

get '/rss.xml' do
  content_type 'text/xml; charset=utf-8'
  entries = update_data()
  generate_feed(entries).to_s
end

def serialize(entries)
  list = {}
  entries.each do |id, entry|
    list[entry.id] = entry.to_obj
  end
  list.to_json
end

def deserialize(json_data)
  result = {}
  JSON.load(json_data).each do |id, entry|
    result[id] = Entry::from_obj(entry)
  end
  result
end

def update_data
  items = MONGO.collection('items')

  # fetch remote data
  #html = IO.read("test.html")
  html = `curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html' -H 'Cookie: Test=Sun, 31 Jan 2100 23:00:00 GMT; ARD-Mediathek=2; xtvrn=$511893$; mobileRedirect=false; Test=Sun, 31 Jan 2100 23:00:00 GMT; ARD-Mediathek=2; ard_mediathek_player_settings=%7B%22lastUsedPlugin%22%3A0%2C%22changedVolumeValue%22%3A0.76%2C%22changedMuteValue%22%3Afalse%2C%22changeSubtitleValue%22%3Afalse%7D' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: www.ardmediathek.de' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://www.ardmediathek.de/fernsehen' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed`
  entries = ARDMediathekParser.new.parse_html(html)
  puts "Retrieved #{entries.size} entries..."
  
  new_items_count = 0
  # for each fetched item
  entries.each do |entry|
    if items.find(:id => entry.id).first.to_a.size == 0
      new_items_count = new_items_count + 1
      if new_items_count >= ITEMS_TO_LOAD_AT_ONCE
        break
      end
      
      puts "NEW ============================================="
      # get details
      ARDMediathekParser.new.parse_details(`curl '#{entry.details_url}'`, entry)
      # add to known list
      #known_entries[entry.id] = entry
      items.insert(entry.to_obj)
      puts entry.to_s
      puts ""
    end
  end
  
  items.find.sort([["discovered", -1]]).limit(25).to_a
end