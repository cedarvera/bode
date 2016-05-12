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
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".event-list-item").map do |elem|
      # It is split into two blocks
      # artists are in the class 'event-content'
      headlinerNode = elem.at(".event-content > .event-content-wrap > h2 > a")
      supportNode   = elem.at(".event-content > .event-content-wrap > h3")
      # date is in the class 'event-list-details'
      dateNode      = elem.at(".event-list-details > .event-details-wrap dd")
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
  end
end
