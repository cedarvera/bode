require_relative "lib/scraper_base"

class Scraper < ScraperBase
  # get the pages and return the resulting html
  def grab_pages
    visit("https://www.sixthandi.org/events/category/arts-entertainment/music/list/")
    yield(page.html)
    # keep checking the next events page when available
    while(has_link?("Next Events »"))
      click_link("Next Events »")
      yield(page.html)
    end
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".event-list-item").map do |elem|
      # It is split into two blocks
      {
        venue:     "Sixth & I Synagogue",
        date:      grab_text(elem, ".event-list-details > .event-details-wrap dd", Date.today),
        headliner: grab_text(elem, ".event-content > .event-content-wrap > h2 > a", ""),
        support:   grab_text(elem, ".event-content > .event-content-wrap > h3", [])
      }
    end
  end
end
