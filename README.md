# Offer viewer

## Introdcution

This is a simple proxy to Fyber's offer api.
The proxy is dedicated to a single app (app id & api key).  
The app id & api key is externalized  
It includes a basic frontend client where you may try out the api with different parameters and the available offers (if any).


## Development

### Pre-requisites
* Ruby 2.2.2
* Bundler

### Environment setup

Setup
```
git clone git@github.com:kallebertell/offerproxy.git
cd offerproxy
bundle install
```

Create a fyber_credentials.rb with your app id & api key, e.g.
```ruby
# don't add me to version control
ENV['FYBER_APP_ID'] ||= "123"
ENV['FYBER_API_KEY'] ||= "ourapikey"
```

Start server
```
bundle exec rackup config.ru
```

Run tests
```
bundle exec rake
```

## Design considerations

I imagined this could be a proxy used internally by a game company to make it easier to consume fyber's offer api,
with the frontend client just being a client among others. It may not work out as such but it shouldn't be far off.

Since I planned for a rest api and a static html/js client, sinatra seemed like the apt choice. I've never used it before but it seemed to do the job and there is a lot less cruft compared to a more monolithic framework (e.g. rails).

For tests we have unit & api specifications. None of the tests communicate with the outside world (i.e. fyber api), but those are mocked out using WebMock.

The frontend client doesn't follow any great SPA architecture, it's just a static html5/bootstrap boilerplate with a single file for application code (main.js). I considered the backend part the meat of the task so the frontend is mostly quick & dirty without tests. Note: Fyber's image CDN seems to return redirects (307) to data url's which Chrome doesn't like cause it doesn't display the images. Safari & Firefox seem fine with it. I didn't consider resolving this part of the task.
