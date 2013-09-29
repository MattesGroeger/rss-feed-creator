require "date"
require "nokogiri"
require_relative "entry"

class ARDMediathekParser
  def parse_html(html)
    entries = []
    doc = Nokogiri::HTML(html)
    doc.css('div.mt-media_item').each do |div|
      title_a = div.xpath('h3/a').first
      image = div.xpath('div/img').first
      source_span = div.css('p.mt-source').first.content
      rating_span = div.css('p.mt-rating').first.content
      channel_span = div.css('span.mt-channel').first.content
      airtime_span = div.css('span.mt-airtime').first.content
      
      entry = Entry.new()
      entry.title = title_a.content
      entry.show = source_span.sub(/aus: /, '')
      entry.channel = channel_span
      entry.url = "http://www.ardmediathek.de" << title_a['href']
      entry.image_url = "http://www.ardmediathek.de" << image['src']
      date, entry.duration = (matches = airtime_span.match(/(^.+) (\d+:\d+) min/i)) ? matches.captures : [airtime_span, "??:??"]
      entry.date = Date::strptime(date, "%d.%m.%y")
      entry.rating = (matches = rating_span.match(/Nutzerbewertung (\d) von \d/i)) ? matches.captures.first : "?"
      entry.id = title_a['href'].match(/.+\?documentId=(.+)$/i).captures.first

      entries << entry
    end
    entries
  end
  
  def parse_details(html, entry)
    doc = Nokogiri::HTML(html)
    headline = doc.xpath('//h3/a').first
    description = doc.xpath('//p').first
    entry.title = headline.content if headline
    entry.description = description.content if description
    entry.discovered = DateTime.now
  end
end