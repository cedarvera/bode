require_relative "../grabber_base"

class Grabber < GrabberBase
  # constructor
  def initialize
    # The url that list all the shows
    @urls = [
      "http://www.930.com/concerts/",
      "http://www.930.com/concerts/merriweather/",
      "http://www.930.com/concerts/lincoln-theatre/",
      "http://www.930.com/concerts/imp/"
    ]
  end
  # Go through the page and find the the shows
  def find_shows
    @urls.map do |url|
      visit(url)
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      shows = all(".vevent").map do |elem|
        headlinerNode = elem.first(".headliners a")
        supportNode   = elem.first(".supports a")
        dateNode      = elem.first(".dates")
        venueNode     = elem.first(".venue")
        # convert the date so we can see the year
        date = convert_date(dateNode.text)
        # create the show object
        {
          # If there is no venue than its at 930 club
          :venue     => venueNode.nil? ?     "930 Club" : venueNode.text,
          :date      => date,
          :headliner => headlinerNode.nil? ? "" : headlinerNode.text,
          :support   => supportNode.nil? ?   [] : supportNode.text.split(",")
        }
      end
      yield(shows.compact.flatten, page.html)
    end
  end
end
