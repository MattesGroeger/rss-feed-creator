require 'spec_helper'

describe "render json" do

  before(:all) do
    Website.destroy_all
    Parser.destroy_all
    Entry.destroy_all
    w = Website.new(key: "ard-mediathek",
                    title: "ARD Mediathek")
    p = Parser.create(file: "mediathek_parser",
                      clazz: "MediathekParser")
    w.streams << Stream.new(key: "doku-reportage",
                            url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html",
                            max_details: 1,
                            parser_id: p._id)
    w.save

    Entry.create(uid: 1, stream_id:w.streams.first._id, title: 'foo', description: 'test', url: 'url', image_url: 'image_url', data: {'custom' => 'value'})
  end

  it "should render json" do
    output = Output.new(stream_ids: [Website.first.streams.first._id], type: 'rss')
    result = Renderer::json(output)

    obj = JSON.parse(result)
    puts obj

    obj['entries'].size.should eq(1)
    obj['entries'].first['data']['custom'].should eq('value')
    obj['entries'].first['description'].should eq('test')
    obj['entries'].first['title'].should eq('foo')
    obj['entries'].first['uid'].should eq('1')
    obj['entries'].first['id'].should_not be_nil
    obj['streams'].size.should eq(1)
    obj['streams'].first['website'].should_not be_nil
  end

end
