require_relative "../grabber_base"

class Grabber < GrabberBase
  # get the pages and return the resulting html
  def grab_pages
    visit("http://www.930.com/concerts/")
    yield(page.html)
    visit("http://www.930.com/concerts/merriweather/")
    yield(page.html)
    visit("http://www.930.com/concerts/lincoln-theatre/")
    yield(page.html)
    visit("http://www.930.com/concerts/imp/")
    yield(page.html)
  end
  # Go through the page and find the the shows
  def find_shows(page)
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
        :venue     => venueNode.nil? ?     "930 Club" : venueNode.text,
        :date      => date,
        :headliner => headlinerNode.nil? ? "" : headlinerNode.text,
        :support   => supportNode.nil? ?   [] : supportNode.text.split(",")
      }
    end
  end
end
