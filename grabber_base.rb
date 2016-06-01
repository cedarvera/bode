require 'date'
require "capybara/dsl"
require "capybara/poltergeist"

Capybara.register_driver :poltergeist do |driver|
  Capybara::Poltergeist::Driver.new(driver, js_errors: false)
end

Capybara.configure do |config|
  config.ignore_hidden_elements = true
  Capybara.current_driver = :poltergeist
  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
  Capybara.default_selector = :css
end

class GrabberBase
  include Capybara::DSL
  # Have each scraper override the grab_pages method and return the shows
  def get_shows
    find_shows do |shows, html|
      {
        shows: shows.flatten.compact,
        html: html
      }
    end
  end
  # convert the date text into the date of the show
  def convert_date(text)
    # use today if not parsable
    date = Date.parse(text) rescue Date.today
    # if its parsed to be before today then its in usually the following year
    if date < Date.today
      date.next_year
    else
      date
    end
  end
end
