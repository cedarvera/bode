require_relative "lib/scraper_base"

class Scraper < ScraperBase
  # get the pages and return the resulting html
  def grab_pages
    visit("https://www.thelincolndc.com/")
    yield(page.html)
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".vevent").map do |elem|
      {
        venue:     "The Lincoln Theatre",
        date:      grab_text(elem, ".dates", Date.today),
        headliner: grab_text(elem, ".headliners a", ""),
        support:   grab_text(elem, ".supports a", [])
      }
    end
  end
end
