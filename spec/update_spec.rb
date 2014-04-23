require_relative '../lib/update.rb'

describe "Update" do

  it "should update 1 new ard doku item remotely" do
    config = {
      url: 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html',
      details_url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{id}}/view=ajax/isFromList=true/index.html",
      max_details: 1,
      parser:      {file: 'mediathek', class: 'ARDMediathekParser'},
    }

    fetcher = Http.new

    storage = double()
    storage.stub(:new_item?) { true }
    storage.should_receive(:save_item).exactly(1).times

    Feed::update(config, fetcher, storage)
  end

  it "should update 5 new local ard doku items" do
    config = {
      url:         'all',
      details_url: 'details',
      parser:      {file: 'mediathek', class: 'ARDMediathekParser'},
    }

    fetcher = double()
    fetcher.stub(:fetch) { |url|
      file = url == "all" ? "doku" : "doku_detail"
      File.read("spec/data/#{file}.html")
    }

    storage = double()
    storage.stub(:new_item?) { true }
    storage.should_receive(:save_item).exactly(5).times

    Feed::update(config, fetcher, storage)
  end

end
