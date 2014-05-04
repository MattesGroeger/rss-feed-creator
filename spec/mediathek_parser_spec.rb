require 'spec_helper'

describe MediathekParser do

  before :all do
    @parser = MediathekParser.new
  end

  it "should parse items" do
    content = File.read("spec/data/doku.html")
    entries = @parser.parse(content)

    entries.should have(200).items

    entry = entries.first
    entry.uid.should eql "20933402"
    entry.title.should eql "Mein Deutschland: Geteilte Heimat"
    entry.url.should eql "http://www.ardmediathek.de/rbb-fernsehen/dokumentation-und-reportage/mein-deutschland-geteilte-heimat?documentId=20933402"
    entry.image_url.should eql "http://www.ardmediathek.de/ard/servlet/contentblob/20/93/34/14/20933414/bild/2347119"

    entry.data[:show].should eql "Dokumentation und Reportage"
    entry.data[:channel].should eql "rbb Fernsehen"
    entry.data[:duration].should eql "43:59"
    entry.data[:date].should eql "2014-04-22"
    entry.data[:rating].should eql "0"
  end

  it "should parse details" do
    content = File.read("spec/data/doku_detail.html")
    entry = Entry.new
    @parser.parse_details(content, entry)

    entry.title.should eql "Mein Deutschland: Geteilte Heimat"
    entry.description.should eql "Der erste Teil widmet sich den Jahren von 1949 bis 1961: der Herausbildung zweier deutscher Staaten und zweier unterschiedlicher Wege, die Folgen ..."
  end

end
