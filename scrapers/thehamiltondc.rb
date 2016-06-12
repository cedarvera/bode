require_relative "lib/scraper_base"

class Scraper < ScraperBase
  # get the pages and return the resulting html
  def grab_pages
    visit("http://live.thehamiltondc.com/listing/")
    yield(page.html)
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".vevent").map do |elem|
      # hamilton has the same format as uhall/930's website
      headlinerNode = elem.at(".headliners a")
      supportNode   = elem.at(".supports a")
      dateNode      = elem.at(".dates")
      # convert the date so we can see the year
      date = convert_date(dateNode.text)
      # create the show object
      {
        :venue     => "The Hamilton",
        :date      => date,
        :headliner => headlinerNode.nil? ? "" : headlinerNode.text,
        :support   => supportNode.nil? ?   [] : supportNode.text.split(",")
      }
    end
  end
end
