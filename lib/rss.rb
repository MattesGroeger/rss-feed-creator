#!/bin/env ruby
# encoding: utf-8

require 'rss'

module Feed

  def self.rss(watch)
    require_relative "formatter/#{watch[:formatter][:file]}"

    entries = Entry.sort(:updated_at.desc).limit(25)

    rss = RSS::Maker.make("2.0") do |rss|
      rss.channel.about = watch[:info][:link]
      rss.channel.title = watch[:info][:title]
      rss.channel.description = watch[:info][:description]
      rss.channel.link = watch[:info][:link]
      rss.channel.language = watch[:info][:language]

      rss.items.do_sort = true
      rss.items.max_size = 100

      entries.each do |entry|
        formatter = Object.const_get(watch[:formatter][:class]).new(entry)

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
