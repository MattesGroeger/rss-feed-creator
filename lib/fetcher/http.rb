require 'rest'

class Http
  def fetch(url)
    REST::get(url).body
  end
end
