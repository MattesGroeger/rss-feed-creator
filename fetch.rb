require 'json'
require 'mongo'
require_relative 'parser'
require_relative 'feed'

MAX_ENTRIES = 300

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
  # read list from disk (known)
  data = File.exist?("database") ? File.read("database") : "{}"
  known_entries = deserialize(data)
  
  # fetch remote data
  #html = IO.read("test.html")
  html = `curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html' -H 'Cookie: Test=Sun, 31 Jan 2100 23:00:00 GMT; ARD-Mediathek=2; xtvrn=$511893$; mobileRedirect=false; Test=Sun, 31 Jan 2100 23:00:00 GMT; ARD-Mediathek=2; ard_mediathek_player_settings=%7B%22lastUsedPlugin%22%3A0%2C%22changedVolumeValue%22%3A0.76%2C%22changedMuteValue%22%3Afalse%2C%22changeSubtitleValue%22%3Afalse%7D' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: www.ardmediathek.de' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://www.ardmediathek.de/fernsehen' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed`
  entries = ARDMediathekParser.new.parse_html(html)
  puts "Retrieved #{entries.size} entries..."
  
  # for each fetched item
  entries.each do |entry|
    if !known_entries[entry.id]
      puts "NEW ============================================="
      # get details
      ARDMediathekParser.new.parse_details(`curl '#{entry.details_url}'`, entry)
      # add to known list
      known_entries[entry.id] = entry
      puts entry.to_s
      puts ""
    end
  end
  
  # remove old entries
  if known_entries.size > MAX_ENTRIES
    # sort by discovery
    values = known_entries.values
    values = values.sort { |a,b| [b.discovered, b.date] <=> [a.discovered, a.date] }
    puts values.size
    entries_to_delete = values.slice(MAX_ENTRIES, values.size - MAX_ENTRIES)
    entries_to_delete.each do |entry|
      puts "DELETE ******************************************* "
      puts entry
      known_entries.delete entry.id
    end
  end
  
  # save 'known' to disk
  json = serialize(known_entries)
  File.open("database","w") do |f|
    f.write(json)
    puts "Saved #{known_entries.size} entries to disk!"
  end
  
  known_entries
end

#puts generate_feed(entries).to_s