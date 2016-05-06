require 'date'
require 'nokogiri'

class GrabberBase
  # get the array of urls to grab from
  @urls = []
  # grab the html at the target url and return a nokogiri object of the html
  def grab_page(url)
    Nokogiri::HTML(`phantomjs --ignore-ssl-errors=true grab.js #{url}`)
  end
  # grab the htmls at the target urls returning a nokogiri object for each
  def grab_pages
    # if urls is nil then default to the one in my urls
    @urls.map do |url|
      grab_page(url)
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
