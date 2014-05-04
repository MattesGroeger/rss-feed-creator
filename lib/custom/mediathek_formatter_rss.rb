# encoding: utf-8

require 'date'

class MediathekFormatterRss
  def initialize(entry)
    @entry = entry
  end

  def title
    "#{@entry.title}, #{@entry.data["duration"]} min"
  end

  def link
    @entry.url
  end

  def date
    @entry.data["date"].to_s
  end

  def description
    stars = ""
    if (@entry.data["rating"].to_i > 0)
      (1..5).each do |index|
        stars << (index <= @entry.data["rating"].to_i ? "★" : "☆")
      end
    end
    "#{@entry.description} #{stars}, #{@entry.data["show"]}, #{@entry.data["channel"]}, #{DateTime.parse(@entry.data["date"]).strftime("%d.%m.%Y")}"
  end
end
