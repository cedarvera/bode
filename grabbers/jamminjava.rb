require_relative "../grabber_base"

class Grabber < GrabberBase
  # get the pages and return the resulting html
  def grab_pages
    visit("http://jamminjava.com/calendar")
    yield(page.html)
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
      date = convert_date(dateNode.text)
      # create the show object
      {
        :venue     => "Jammin' Java",
        :date      => date,
        :headliner => headlinerNode.nil? ? "" : headlinerNode.text,
        :support   => supportNode.nil? ?   [] : supportNode.text.split(",")
      }
    end
  end
end
