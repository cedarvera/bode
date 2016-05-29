require 'date'
require 'nokogiri'
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
  # get the array of urls to grab from
  @urls = []
  # grab the html at the target url and return a nokogiri object of the html
  def grab_page(url)
    visit(url)
    Nokogiri::HTML(page.html)
  end
  # grab the htmls at the target urls returning a nokogiri object for each
  def grab_pages
    @urls.map { |url| grab_page(url) }
  end
  # Go through each url to get the shows
  def get_shows
    grab_pages.map do |page|
      shows = find_shows(page).flatten.compact
      {
        html: page,
        shows: shows
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
