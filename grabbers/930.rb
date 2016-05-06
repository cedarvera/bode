require_relative "../grabber-base"

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
  # Go through each url to get the shows
  def shows
    events = grab_pages.map do |page|
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      page.search(".vevent").map do |elem|
        headlinerNode = elem.at(".headliners a")
        supportNode   = elem.at(".supports a")
        dateNode      = elem.at(".dates")
        venueNode     = elem.at(".venue")
        # convert the date so we can see the year
        date = convert_date(dateNode.text)
        # create the show object
        {
          # If there is no venue than its at 930 club
          :venue     => venueNode == nil ?     "930 Club" : venueNode.text,
          :date      => date,
          :headliner => headlinerNode == nil ? "" : headlinerNode.text,
          :support   => supportNode == nil ?   [] : supportNode.text.split(",")
        }
      end
    end
    events.flatten.compact
  end
end
