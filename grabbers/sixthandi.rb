require_relative "../grabber_base"

class Grabber < GrabberBase
  # constructor
  def initialize
    # The url that list all the shows
    @urls = [
      "https://www.sixthandi.org/events/category/arts-entertainment/music/list/"
    ]
  end
  # Go through the page and find the the shows
  def find_shows
    @urls.map do |url|
      visit(url)
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      shows = all(".event-list-item").map do |elem|
        # It is split into two blocks
        # artists are in the class 'event-content'
        headlinerNode = elem.first(".event-content > .event-content-wrap > h2 > a")
        supportNode   = elem.first(".event-content > .event-content-wrap > h3")
        # date is in the class 'event-list-details'
        dateNode      = elem.first(".event-list-details > .event-details-wrap dd")
        # convert the date so we can see the year
        date = convert_date(dateNode.text)
        # create the show object
        {
          :venue     => "Sixth & I Synagogue",
          :date      => date,
          :headliner => headlinerNode.nil? ? "" : headlinerNode.text,
          :support   => supportNode.nil? ?   [] : supportNode.text.split(",")
        }
      end
      yield(shows.compact.flatten, page.html)
    end
  end
end
