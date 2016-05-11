require_relative "../grabber-base"

class Grabber < GrabberBase
  # constructor
  def initialize
    @urls = [
      "http://jamminjava.com/calendar"
    ]
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".vevent").map do |elem|
      # jammin java has the same format as 930's website
      headlinerNode = elem.at(".headliners a")
      supportNode   = elem.at(".supports a")
      dateNode      = elem.at(".dates")
      # convert the date so we can see the year
      date = self.convert_date(dateNode.text)
      # create the show object
      {
        :venue     => "Jammin' Java",
        :date      => date,
        :headliner => headlinerNode == nil ? "" : headlinerNode.text,
        :support   => supportNode == nil ?   [] : supportNode.text.split(",")
      }
    end
  end
end
