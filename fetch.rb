require_relative "parser"

html = IO.read("test.html")
#html = `curl 'http://www.ardmediathek.de/ard/servlet/ajax-cache/3474718/view=switch/index.html' -H 'Cookie: Test=Sun, 31 Jan 2100 23:00:00 GMT; ARD-Mediathek=2; xtvrn=$511893$; mobileRedirect=false; Test=Sun, 31 Jan 2100 23:00:00 GMT; ARD-Mediathek=2; ard_mediathek_player_settings=%7B%22lastUsedPlugin%22%3A0%2C%22changedVolumeValue%22%3A0.76%2C%22changedMuteValue%22%3Afalse%2C%22changeSubtitleValue%22%3Afalse%7D' -H 'Accept-Encoding: gzip,deflate,sdch' -H 'Host: www.ardmediathek.de' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36' -H 'Accept: */*' -H 'Referer: http://www.ardmediathek.de/fernsehen' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed`

entries = ARDMediathekParser.new.parse_html(html)

puts "Retrieved #{entries.size} entries!"