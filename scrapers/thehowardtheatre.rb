require_relative "lib/scraper_base"

class Scraper < ScraperBase
  # get the pages and return the resulting html
  def grab_pages
    visit("http://thehowardtheatre.com/calendar/")
    yield(page.html)
  end
  # Go through the page and find the the shows
  # The layout is crazy !? (uses fullcalendar)
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search("a.fc-event").map do |elem|
      # TODO: Grab the date from the column?
      # Grab date from the href it looks like the format of "{url}/show/YYYY/MM/DD/{rest of url}"
      href = elem["href"]
      # no link, then no date
      next if href.nil?
      href.strip!
      # if no "show" then it is a private event
      next unless href.include?("show")
      # make sure there is a date
      match = href.match(/[[:digit:]]+\/[[:digit:]]+\/[[:digit:]]+/)[0]
      next if match.nil?
      # convert the date so we can see the year
      date = convert_date(match)

      {
        venue:     "The Howard Theatre",
        date:      date,
        headliner: grab_text(elem, ".headliner", ""),
        # grab the siblings after the headliner element
        support:   grab_text(elem, ".headliner ~ small", [])
      }
    end
  end
end
