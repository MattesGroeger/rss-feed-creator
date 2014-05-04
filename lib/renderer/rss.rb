# encoding: utf-8

require 'rss'

module Renderer

  def self.rss(output)
    require_relative "../custom/#{output.config['file']}"

    website = Website.where('streams._id' => output.stream_ids.first).first
    entries = Entry.sort(:updated_at.desc).limit(output.config['item_count'])

    result = RSS::Maker.make("2.0") do |rss|
      rss.channel.about = website.url
      rss.channel.title = website.title
      rss.channel.description = output.description
      rss.channel.link = website.url

      rss.items.do_sort = true
      rss.items.max_size = 100

      entries.each do |entry|
        formatter = Object.const_get(output.config['class']).new(entry)

        xml = rss.items.new_item
        xml.title = formatter.title
        xml.link = formatter.link
        xml.description = formatter.description
        xml.date = formatter.date
      end
    end

    result.to_s
  end

end
