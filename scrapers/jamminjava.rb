require_relative "lib/scraper_base"

class Scraper < ScraperBase
  # get the pages and return the resulting html
  def grab_pages
    visit("http://jamminjava.com/calendar")
    yield(page.html)

    while(has_link?(">"))
      visit(find_link(">")[:href])
      yield(page.html)
    end
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".vevent").map do |elem|
      # jammin java has the same format as 930's website
      {
        venue:     "Jammin' Java",
        date:      grab_text(elem, ".dates", Date.today),
        headliner: grab_text(elem, ".headliners a", ""),
        support:   grab_text(elem, ".supports", [])
      }
    end
  end
end
