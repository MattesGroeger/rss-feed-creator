require_relative '../lib/update.rb'

shared_examples "ard mediathek" do |url, details_url|

  it "should update 1 new item remotely" do
    config = {
      url: url,
      details_url: details_url,
      max_details: 1,
      parser:      {file: 'mediathek', class: 'ARDMediathekParser'},
    }

    fetcher = Http.new

    storage = double()
    storage.stub(:new_item?) { true }
    storage.should_receive(:save_item).exactly(1).times

    Feed::update(config, fetcher, storage)
  end
end

describe "fetching from ard mediathek" do

  it_should_behave_like "ard mediathek",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{id}}/view=ajax/isFromList=true/index.html"

  it_should_behave_like "ard mediathek",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/4585472/view=switch/index.html",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{id}}/view=ajax/isFromList=true/index.html"

end

describe "Parsing cached files" do

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
