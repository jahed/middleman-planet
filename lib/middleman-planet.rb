require 'middleman-core'

class PlanetExtension < ::Middleman::Extension
  option :feeds, {}, 'A mapping of keys to feeds to aggregate'
  option :fail_on_feed_error, true, 'Whether to fail when a feed has an error'

  def initialize(app, options_hash={}, &block)
    super

    require 'colorize'
    require 'feedjira'
  end

  def after_configuration
    feeds = options.feeds
    entries = []

    urls = []
    url_to_key_hash = {}
    feeds.each { |key, feed|
      url = feed[:url]
      urls << url
      url_to_key_hash[url] = key
    }

    errors = {}
    Feedjira::Feed.fetch_and_parse urls,
      on_success: lambda { |url, feed|
        key = url_to_key_hash[url]
        feeds[key][:feed] = feed

        entries.push(feeds[key][:limit] ? feed.entries.take(feeds[key][:limit]) : feed.entries)

        puts "[planet][feeds.#{url_to_key_hash[url]}] Retrieved #{feed.entries.size} entries."
      },
      on_failure: lambda { |curl, err|
        errors[curl] = err
        feeds.delete(url_to_key_hash[curl.url])
        puts "[planet][feeds.#{url_to_key_hash[curl.url]}] #{err} (HTTP Response #{curl.response_code})".red
      }

    if not errors.empty? and options.fail_on_feed_error
      raise (
        "\n" +
        "\n  middleman-planet failed to retrieve #{errors.size} feeds" +
        "\n    - Use the `planet.fail_on_feed_error = false` option to ignore these." +
        "\n"
      ).red
    end

    puts "[planet] Aggregated #{entries.size} entries from #{feeds.size} feeds.".green

    planet = {
      entries: entries,
      feeds: feeds
    }
    app.set :feeds, feeds
  end

end

PlanetExtension.register(:planet)
