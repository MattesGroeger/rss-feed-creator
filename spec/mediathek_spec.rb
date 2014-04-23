require_relative '../lib/parser/mediathek.rb'

describe ARDMediathekParser do

  before :all do
    @parser = ARDMediathekParser.new
  end

  it "should parse items" do
    content = File.read("spec/data/doku.html")
    items = @parser.parse(content)

    items.should have(200).items

    item = items.first
    item[:id].should eql "20933402"
    item[:title].should eql "Mein Deutschland: Geteilte Heimat"
    item[:show].should eql "Dokumentation und Reportage"
    item[:channel].should eql "rbb Fernsehen"
    item[:url].should eql "http://www.ardmediathek.de/rbb-fernsehen/dokumentation-und-reportage/mein-deutschland-geteilte-heimat?documentId=20933402"
    item[:image_url].should eql "http://www.ardmediathek.de/ard/servlet/contentblob/20/93/34/14/20933414/bild/2347119"
    item[:duration].should eql "43:59"
    item[:date].should eql "2014-04-22"
    item[:rating].should eql "0"
  end

  it "should parse details" do
    content = File.read("spec/data/doku_detail.html")
    item = {}
    @parser.parse_details(content, item)

    item[:title].should eql "Mein Deutschland: Geteilte Heimat"
    item[:description].should eql "Der erste Teil widmet sich den Jahren von 1949 bis 1961: der Herausbildung zweier deutscher Staaten und zweier unterschiedlicher Wege, die Folgen ..."
  end

end
