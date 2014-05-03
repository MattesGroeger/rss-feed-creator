require 'date'
require 'nokogiri'

class ARDMediathekParser
  def parse(content)
    entries = []
    doc = Nokogiri::HTML(content)
    doc.css('div.mt-media_item').each do |div|
      title_a = div.xpath('h3/a').first
      image = div.xpath('div/img').first
      source_span = div.css('p.mt-source').first.content
      rating_span = div.css('p.mt-rating').first.content
      channel_span = div.css('span.mt-channel').first.content
      airtime_span = div.css('span.mt-airtime').first.content

      date, duration = (matches = airtime_span.match(/(^.+) (\d+:\d+) min/i)) ? matches.captures : [airtime_span, "??:??"]

      entries << Entry.new(
        uid:        title_a['href'].match(/.+\?documentId=(.+)$/i).captures.first,
        title:      title_a.content,
        url:        "http://www.ardmediathek.de" << title_a['href'],
        image_url:  "http://www.ardmediathek.de" << image['src'],
        data:       {
          show:     source_span.sub(/aus: /, ''),
          channel:  channel_span,
          duration: duration,
          date:     Date::strptime(date, "%d.%m.%y").to_s,
          rating:   (matches = rating_span.match(/Nutzerbewertung (\d) von \d/i)) ? matches.captures.first : "?"
        }
      )
    end
    entries
  end

  def parse_details(content, entry)
    doc = Nokogiri::HTML(content)

    headline = doc.xpath('//h3/a').first
    description = doc.xpath('//p').first

    entry.title       = headline.content if headline
    entry.description = description.content if description
  end
end
