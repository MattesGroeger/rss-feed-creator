# encoding: utf-8

module Feed
  
  DETAIL_ITEMS_TO_LOAD_AT_ONCE = 5
  
  def self.fetch(watch, storage)
    require_relative "watches/#{watch[:require]}"
    
    parser_type = Object.const_get(watch[:parser])
    parser = parser_type.new
    items = parser.parse()
    
    puts "Retrieved #{items.size} items..."

    new_items_count = 0

    items.reverse.each do |item|
      
      if storage.new_item?(item)
        puts "NEW ============================================="
        
        if parser_type.method_defined? :parse_details
          puts "Retrieving details..."
          new_items_count = new_items_count + 1
          if new_items_count >= DETAIL_ITEMS_TO_LOAD_AT_ONCE
            break
          end
          parser.parse_details(item)
        end

        storage.save_item(item)
        puts item.to_s + "\n\n"
      end
    end
  end
  
end