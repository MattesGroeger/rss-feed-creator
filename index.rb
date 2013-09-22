require 'sinatra'
require 'rss'
require_relative 'parser'
require_relative 'feed'

get '/feed.xml' do
  content_type 'text/xml; charset=utf-8'
  html = IO.read("test.html")
  #html = `curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html' -H 'Cookie: ARD-Mediathek=2; xtvrn=$511893$; mobileRedirect=false;' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: www.ardmediathek.de' -H 'Accept: */*' -H 'Referer: http://www.ardmediathek.de/fernsehen' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed`
  
  entries = ARDMediathekParser.new.parse_html(html)
  generate_feed(entries).to_s

end