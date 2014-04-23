# encoding: utf-8

require 'date'

class ARDMediathekFeedFormatter
  def initialize(item)
    @item = item
  end

  def title
    "#{@item['title']}, #{@item['duration']} min"
  end

  def link
    @item['url']
  end

  def date
    @item['date'].to_s
  end

  def description
    stars = ""
    if (@item['rating'].to_i > 0)
      (1..5).each do |index|
        stars << (index <= @item['rating'].to_i ? "★" : "☆")
      end
    end
    "#{@item['description']} #{stars}, #{@item['show']}, #{@item['channel']}, #{DateTime.parse(@item['date']).strftime("%d.%m.%Y")}"
  end
end
