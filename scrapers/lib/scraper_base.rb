require 'date'
require 'nokogiri'
require "capybara/dsl"
require "selenium-webdriver"

Capybara.configure do |config|
  config.ignore_hidden_elements = true
  Capybara.default_driver = :selenium_chrome_headless
  Capybara.javascript_driver = :selenium_chrome_headless
  Capybara.default_max_wait_time = 300
end

# to differentiate from the dsl commands prefix with grab
class ScraperBase
  include Capybara::DSL
  # attempt to get the text of an element, else return the default
  def grab_text(elem, selector, default)
    node = elem.at(selector)
    return default if node.nil?
    text = node.text.strip
    case default
    when String then text
    when Array then text.split(",").map { |t| t.strip }
    when Date then convert_date(text)
    else
      default
    end
  end
  # Go through each url to get the shows
  def grab_shows
    grab_pages do |html|
      shows = find_shows(Nokogiri::HTML(html)).flatten.compact
      yield({
        html: html,
        shows: shows
      })
    end
  end
  # convert the date text into the date of the show
  def convert_date(text)
    date = Date.parse(text)
    # if its parsed to be before today then its in usually the following year
    date.next_year if date < Date.today
    # return date
    date
  rescue
    # use today if not parsable
    Date.today
  end
end
