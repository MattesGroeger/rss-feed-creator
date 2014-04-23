# encoding: utf-8

require 'sinatra'
require 'newrelic_rpm'
require_relative 'fetcher/http'
require_relative 'storage'
require_relative 'update'
require_relative 'rss'

WATCHES = {
  ard: {
    info: {
      title: 'ARD Mediathek Reportage & Doku',
      description: 'ARD Mediathek Reportage & Doku',
      link: 'http://www.ardmediathek.de/fernsehen',
      language: 'de'
    },
    url: 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html',
    details_url: "http://www.ardmediathek.de/ard/servlet/ajax-cache/{{id}}/view=ajax/isFromList=true/index.html",
    max_details: 5,
    parser: {file: 'mediathek', class: 'ARDMediathekParser'},
    formatter: {file: 'mediathek_rss', class: 'ARDMediathekFeedFormatter'},
    storage: 'items'
  }
}

get '/rss.xml' do
  watch = WATCHES[:ard]
  storage = Feed::Storage.new(watch[:storage])

  content_type 'text/xml; charset=utf-8'

  Feed::update(watch, Http.new, storage)
  Feed::rss(watch, storage)
end
