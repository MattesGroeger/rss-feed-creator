#!/bin/env ruby
# encoding: utf-8

require 'rss'

module Feed
  
  def self.rss(watch, storage)
    items = storage.items(25)
    
    rss = RSS::Maker.make("2.0") do |rss|
      rss.channel.about = watch[:info][:link]
      rss.channel.title = watch[:info][:title]
      rss.channel.description = watch[:info][:description]
      rss.channel.link = watch[:info][:link]
      rss.channel.language = watch[:info][:language]
  
      rss.items.do_sort = true
      rss.items.max_size = 100
  
      items.each do |item|
        formatter = Object.const_get(watch[:formatter]).new(item)
        
        xml = rss.items.new_item
        xml.title = formatter.title
        xml.link = formatter.link
        xml.description = formatter.description
        xml.date = formatter.date
      end
    end
    
    rss.to_s
  end
  
end