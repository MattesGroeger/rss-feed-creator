# encoding: utf-8

require "date"
require "nokogiri"

class ARDMediathekParser
  def parse()
    items = []
    doc = Nokogiri::HTML(`curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html'`)
    doc.css('div.mt-media_item').each do |div|
      title_a = div.xpath('h3/a').first
      image = div.xpath('div/img').first
      source_span = div.css('p.mt-source').first.content
      rating_span = div.css('p.mt-rating').first.content
      channel_span = div.css('span.mt-channel').first.content
      airtime_span = div.css('span.mt-airtime').first.content
      
      date, duration = (matches = airtime_span.match(/(^.+) (\d+:\d+) min/i)) ? matches.captures : [airtime_span, "??:??"]
      
      items << {
        :title => title_a.content,
        :show => source_span.sub(/aus: /, ''),
        :channel => channel_span,
        :url => "http://www.ardmediathek.de" << title_a['href'],
        :image_url => "http://www.ardmediathek.de" << image['src'],
        :duration => duration,
        :date => Date::strptime(date, "%d.%m.%y").to_s,
        :rating => (matches = rating_span.match(/Nutzerbewertung (\d) von \d/i)) ? matches.captures.first : "?",
        :id => title_a['href'].match(/.+\?documentId=(.+)$/i).captures.first
      }
    end
    items
  end
  
  def parse_details(item)
    doc = Nokogiri::HTML(`curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/#{item[:id]}/view=ajax/isFromList=true/index.html'`)
    headline = doc.xpath('//h3/a').first
    description = doc.xpath('//p').first
    item[:title] = headline.content if headline
    item[:description] = description.content if description
  end
end

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