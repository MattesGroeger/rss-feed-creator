[![Code Climate](https://codeclimate.com/github/MattesGroeger/rss-feed-creator.png)](https://codeclimate.com/github/MattesGroeger/rss-feed-creator)

Feed creator for various web pages.

### Technology stack

* Ruby app using Sinatra
* Nokogiri to screen-scrape html
* MongoDB for persistence
* Deployment via Heroku

### Start the app locally

```shell
$ bundle install
$ sudo mongod
$ shotgun lib/index.rb
```
