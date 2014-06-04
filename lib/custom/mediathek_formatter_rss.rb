# encoding: utf-8

require 'date'

class MediathekFormatterRss
  def initialize(entry)
    @entry = entry
  end

  def title
    "#{@entry.data["title"]}, #{@entry.data["duration"]}"
  end

  def link
    @entry.data["url"]
  end

  def date
    @entry.createdAt.to_s
  end

  def description
    "#{@entry.data["show"]}, #{@entry.data["channel"]}, #{@entry.data["date"]}"
  end
end
