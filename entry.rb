require "date"
require "digest/md5"

class Entry
  
  attr_accessor :title, :date, :channel, :show, :image_url, :url, :duration, :rating

  @title
  @date
  @channel
  @show
  @image_url
  @url
  @duration
  @rating

  def hash
    Digest::MD5.hexdigest("#{@date}/#{@title}")
  end

  def to_s
    "Title: #{@title}\n"\
    "Date: #{@date}\n"\
    "Channel: #{@channel}\n"\
    "Show: #{@show}\n"\
    "Image: #{@image_url}\n"\
    "URL: #{@url}\n"\
    "Duration: #{@duration}\n"\
    "Rating: #{@rating}/5\n"\
    "Hash: #{hash}\n"
  end

end