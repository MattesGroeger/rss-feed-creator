#!/bin/env ruby
# encoding: utf-8

require 'rss'

def generate_feed(entries)
  rss = RSS::Maker.make("2.0") do |rss|
    rss.channel.about = 'http://www.ard.de/home/ard/RSS_Feeds_der_ARD/89464/index.html'
    rss.channel.title = "ARD Mediathek Reportage & Doku"
    rss.channel.description = "ARD Mediathek Reportage & Doku"
    rss.channel.link = 'http://www.ardmediathek.de/fernsehen'
    rss.channel.language = "de"

    rss.items.do_sort = true
    rss.items.max_size = 15

    entries.each do |entry|
      xml = rss.items.new_item
      xml.title       = entry.title
      xml.link        = entry.url
      xml.description = "Sender: #{entry.channel}, Sendung: #{entry.show}, Länge: #{entry.duration}, Wertung: #{entry.rating}/5"
      xml.date        = entry.date.to_s
    end
  end
end