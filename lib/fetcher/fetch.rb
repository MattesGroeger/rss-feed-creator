# encoding: utf-8

require "pp"
require_relative "http"
require_relative "../util/string"

module Fetcher

  DETAIL_ENTRIES_TO_LOAD_AT_ONCE = 5

  def self.fetch(stream, fetcher)
    require_relative "../custom/#{stream.parser.file}"

    parser_type = Object.const_get(stream.parser.clazz)
    parser = parser_type.new
    entries = parser.parse(fetcher.fetch(stream.url))

    puts "Retrieved #{entries.size} entries..."

    new_entries_count = 0
    max_details = stream.max_details || DETAIL_ENTRIES_TO_LOAD_AT_ONCE

    entries.reverse.each do |entry|

      if Entry.where(uid: entry.uid).count == 0
        if parser_type.method_defined? :parse_details
          new_entries_count = new_entries_count + 1
          if new_entries_count > max_details
            break
          end
          details_url = stream.details_url.replace_vars(entry)
          parser.parse_details(fetcher.fetch(details_url), entry)
        end

        puts "\nNEW =============================================\n\n"
        pp entry

        entry.stream_id = stream._id
        entry.save
      else
        entry.destroy
      end
    end
  end

end
