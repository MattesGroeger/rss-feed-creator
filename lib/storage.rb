# encoding: utf-8

require 'mongo'

module Feed
  
  DATABASE_URI = ENV['DATABASE_URI'] || 'mongodb://localhost'
  MONGO = Mongo::MongoClient.from_uri(DATABASE_URI).db("rssfeed")
  
  class Storage
    def initialize(db)
      @items = MONGO.collection(db)
    end
    
    def new_item?(item)
      @items.find(:id => item[:id]).first.to_a.size == 0
    end
    
    def save_item(item)
      item[:discovered] = DateTime.now.to_s
      @items.insert(item)
    end
    
    def items(limit = 25)
      @items.find
        .sort([["discovered", -1]])
        .limit(limit)
        .to_a
    end
  end
end