require 'date'
require 'nokogiri'

class GrabberBase
  # get the array of urls to grab from
  def self.grab_urls
    # no urls, return an empty array
    []
  end
  # grab the html at the target url and return a nokogiri object of the html
  def self.grab_page(url)
    Nokogiri::HTML(`phantomjs --ignore-ssl-errors=true grab.js #{url}`)
  end
  # grab the htmls at the target urls returning a nokogiri object for each
  def self.grab_pages(urls)
    # if urls is nil then default to the one in my urls
    urls = self.grab_urls unless urls
    urls.map do |url|
      grab_page(url)
    end
  end
  # convert the date text into the date of the show
  def self.convert_date(text)
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
