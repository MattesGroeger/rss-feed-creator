require 'sinatra'
require_relative "parser"

get '/' do
  content_type :txt
  html = `curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html' -H 'Cookie: ARD-Mediathek=2; xtvrn=$511893$; mobileRedirect=false;' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: www.ardmediathek.de' -H 'Accept: */*' -H 'Referer: http://www.ardmediathek.de/fernsehen' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed`
  
  output = ""
  
  entries = ARDMediathekParser.new.parse_html(html)
  entries.each do |entry|
    output << entry.to_s
    output << "\n"
  end

  output

end
