require_relative "../grabber-base"

class Grabber < GrabberBase
  # The url that list all the shows
  def self.grab_urls
    [
      "http://live.thehamiltondc.com/listing/"
    ]
  end
  # Go through each url to get the shows
  def self.shows
    events = self.grab_pages(self.grab_urls).map do |page|
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      page.search(".vevent").map do |elem|
        # hamilton has the same format as uhall/930's website
        headlinerNode = elem.at(".headliners a")
        supportNode   = elem.at(".supports a")
        dateNode      = elem.at(".dates")
        # convert the date so we can see the year
        date = self.convert_date(dateNode.text)
        # create the show object
        {
          :venue     => "The Hamilton",
          :date      => date,
          :headliner => headlinerNode == nil ? "" : headlinerNode.text,
          :support   => supportNode == nil ?   [] : supportNode.text.split(",")
        }
      end
    end
    events.flatten.compact
  end
end