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

## Project Components

#### Content Parser

* HTTP Call (Method, Headers, Endpoint)
* Details-Call per entry
* Mapping of Content to Data model
* Content Types: FeedEntry, ShopEntry

#### Config

* Category config
  * Name, Link, Image
  * Update interval
* Parser config
  * HTML Scraper
  * JSON Parser
* Output config
  * type (rss|json)
  * type-config (e.g. entry_count & mapper for rss)
  * streams[]

#### Database

* Categories
* Entries
  * id, addDate, seen, fav, custom fields

#### Renderer

* FeedRenderer
* ImageRenderer
