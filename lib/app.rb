# encoding: utf-8

require 'sinatra'
require_relative 'storage'
require_relative 'fetch'
require_relative 'rss'

WATCHES = {
  :ard => {
    :info => {
      :title => "ARD Mediathek Reportage & Doku",
      :description => "ARD Mediathek Reportage & Doku",
      :link => "http://www.ardmediathek.de/fernsehen",
      :language => "de"
    },
    :require => "ard",
    :parser => "ARDMediathekParser",
    :formatter => "ARDMediathekFeedFormatter",
    :storage => "items"
  }
}

get '/rss.xml' do
  watch = WATCHES[:ard]
  storage = Feed::Storage.new(watch[:storage])

  content_type 'text/xml; charset=utf-8'
  
  Feed::fetch(watch, storage)
  Feed::rss(watch, storage)
end