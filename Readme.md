[![Code Climate](https://codeclimate.com/github/MattesGroeger/rss-feed-creator.png)](https://codeclimate.com/github/MattesGroeger/rss-feed-creator)

Feed creator for ARD Mediathek (Reportage & Doku).

### Technology stack

* Ruby app using Sinatra
* Nokogiri to screen-scrape html
* MongoDB for persistence
* Deployment via Heroku

### Start the app locally

```shell
$ bundle install
$ rake start
$ shotgun lib/index.rb
```
