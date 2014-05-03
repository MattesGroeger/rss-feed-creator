require 'spec_helper'

shared_examples "ard mediathek" do |url, details_url|

  it "should update 1 new item remotely" do

    stream = Website.first.streams.first
    stream.url = url
    stream.details_url = details_url
    stream.save

    fetcher = Http.new

    Feed::update(stream, fetcher)

    expect(Entry.all.count).to eq(1)
  end
end

describe "fetching from ard mediathek" do

  before(:all) do
    w = Website.new(key: "ard-mediathek",
                    title: "ARD Mediathek")
    p = Parser.create(file: "mediathek",
                      clazz: "ARDMediathekParser")
    w.streams << Stream.new(key: "doku-reportage",
                            url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html",
                            max_details: 1,
                            parser_id: p._id)
    pp w
    w.save
  end

  before(:each) do
    Entry.destroy_all
  end

  after(:each) do
    Entry.destroy_all
  end

  it_should_behave_like "ard mediathek",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{id}}/view=ajax/isFromList=true/index.html"

  it_should_behave_like "ard mediathek",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/4585472/view=switch/index.html",
    "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{id}}/view=ajax/isFromList=true/index.html"

end

describe "Parsing cached files" do

  it "should update 5 new local ard doku items" do
    stream = Website.first.streams.first
    stream.url = 'all'
    stream.details_url = 'details'
    stream.max_details = 5

    fetcher = double()
    fetcher.stub(:fetch) { |url|
      file = url == "all" ? "doku" : "doku_detail"
      File.read("spec/data/#{file}.html")
    }

    Feed::update(stream, fetcher)

    expect(Entry.all.count).to eq(5)
  end

end
