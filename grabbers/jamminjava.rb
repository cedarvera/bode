require_relative "../grabber_base"

class Grabber < GrabberBase
  # constructor
  def initialize
    @urls = [
      "http://jamminjava.com/calendar"
    ]
  end
  # Go through the page and find the the shows
  def find_shows
    @urls.map do |url|
      visit(url)
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      shows = all(".vevent").map do |elem|
        # jammin java has the same format as 930's website
        headlinerNode = elem.first(".headliners a")
        supportNode   = elem.first(".supports a")
        dateNode      = elem.first(".dates")
        # convert the date so we can see the year
        date = convert_date(dateNode.text)
        # create the show object
        {
          :venue     => "Jammin' Java",
          :date      => date,
          :headliner => headlinerNode.nil? ? "" : headlinerNode.text,
          :support   => supportNode.nil? ?   [] : supportNode.text.split(",")
        }
      end
      yield(shows.compact.flatten, page.html)
    end
  end
end
