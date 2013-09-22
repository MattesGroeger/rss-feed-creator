require "date"
require "json"

class Entry
  
  attr_accessor :title, :description, :date, :discovered, :channel, :show, :image_url, :url, :duration, :rating, :id

  @title
  @description
  @date
  @discovered
  @channel
  @show
  @image_url
  @url
  @duration
  @rating
  @id

  def details_url
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/#{@id}/view=ajax/isFromList=true/index.html".strip
  end
  
  def to_s
    "Title: #{@title}\n"\
    "Description: #{@description}\n"\
    "Date: #{@date}\n"\
    "Discovered: #{@discovered}\n"\
    "Channel: #{@channel}\n"\
    "Show: #{@show}\n"\
    "Image: #{@image_url}\n"\
    "URL: #{@url}\n"\
    "Duration: #{@duration}\n"\
    "Rating: #{@rating}/5\n"\
    "ID: #{@id}"
  end
  
  def to_obj
    {
      "title" => @title,
      "description" => @description,
      "date" => @date.to_s,
      "discovered" => @discovered.to_s,
      "channel" => @channel,
      "show" => @show,
      "image_url" => @image_url,
      "url" => @url,
      "duration" => @duration,
      "rating" => @rating,
      "id" => @id
    }
  end
  
  def self.from_obj(obj)
    entry = self.new
    entry.title = obj["title"]
    entry.description = obj["description"]
    entry.date = Date.parse(obj["date"])
    entry.discovered = DateTime.parse(obj["discovered"]) if obj["discovered"] != ""
    entry.channel = obj["channel"]
    entry.show = obj["show"]
    entry.image_url = obj["image_url"]
    entry.url = obj["url"]
    entry.duration = obj["duration"]
    entry.rating = obj["rating"]
    entry.id = obj["id"]
    entry
  end

end