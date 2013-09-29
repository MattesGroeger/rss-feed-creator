require 'sinatra'
require 'rss'
require 'mongo'
require_relative 'parser'
require_relative 'feed'

ITEMS_TO_LOAD_AT_ONCE = 5
DATABASE_URI = ENV['DATABASE_URI'] || 'mongodb://localhost'
MONGO = Mongo::MongoClient.from_uri(DATABASE_URI).db("rssfeed")

get '/rss.xml' do
  content_type 'text/xml; charset=utf-8'
  entries = update_data()
  generate_feed(entries).to_s
end

def update_data
  items = MONGO.collection('items')

  # fetch remote data
  html = `curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html'`
  entries = ARDMediathekParser.new.parse_html(html)
  puts "Retrieved #{entries.size} entries..."
  
  new_items_count = 0
  
  # for each fetched item
  entries.reverse.each do |entry|
    if items.find(:id => entry[:id]).first.to_a.size == 0
      new_items_count = new_items_count + 1
      if new_items_count >= ITEMS_TO_LOAD_AT_ONCE
        break
      end
      
      puts "NEW ============================================="
      # get details
      ARDMediathekParser.new.parse_details(`curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/#{entry[:id]}/view=ajax/isFromList=true/index.html'`, entry)
      items.insert(entry)
      puts entry.to_s + "\n\n"
    end
  end
  
  items.find.sort([["discovered", -1]]).limit(25).to_a
end