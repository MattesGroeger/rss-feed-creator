# encoding: utf-8

require "pp"
require_relative "fetcher/http"
require_relative "util/string"

module Feed

  DETAIL_ITEMS_TO_LOAD_AT_ONCE = 5

  def self.update(config, fetcher, storage)
    require_relative "parser/#{config[:parser][:file]}"

    parser_type = Object.const_get(config[:parser][:class])
    parser = parser_type.new
    items = parser.parse(fetcher.fetch(config[:url]))

    puts "Retrieved #{items.size} items..."

    new_items_count = 0
    max_details = config[:max_details] || DETAIL_ITEMS_TO_LOAD_AT_ONCE

    items.reverse.each do |item|

      if storage.new_item?(item)
        if parser_type.method_defined? :parse_details
          new_items_count = new_items_count + 1
          if new_items_count > max_details
            break
          end
          details_url = config[:details_url].replace_vars(item)
          parser.parse_details(fetcher.fetch(details_url), item)
        end

        storage.save_item(item)
        puts "\nNEW =============================================\n\n"
        pp item
      end
    end
  end

end
