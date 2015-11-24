require_relative "grabber"

class GrabJamminJava < Grabber
  # The url that list all the shows
  def grab_urls
    [
      "http://jamminjava.com/calendar"
    ]
  end
  # Go through each url to get the shows
  def shows
    self.grab_pages(self.grab_urls).map do |page|
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      page.search(".vevent").map do |elem|
        # uhall has the same format as 930's website
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
end

p(GrabJamminJava.new.shows)
