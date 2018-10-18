require_relative "lib/scraper_base"

class Scraper < ScraperBase
  # get the pages and return the resulting html
  def grab_pages
    visit("http://www.930.com/")
    yield(page.html)
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".upcoming-view.grid .vevent").map do |day|
      date = grab_text(day, ".date-ymd", Date.today)
      day.search(".one-event").map do |elem|
        {
          venue:     "930 Club",
          date:      date,
          headliner: grab_text(elem, ".headliners a", ""),
          support:   grab_texts(elem, ".supports a", "")
        }
      end
    end
  end
end
