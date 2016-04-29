require_relative "../grabber-base"

class Grabber < GrabberBase
  # get the array of urls to grab from
  def self.grab_urls
    # The url that list all the shows
    [
      "https://www.sixthandi.org/events/category/arts-entertainment/music/list/"
    ]
  end
  # Go through each url to get the shows
  def self.shows
    events = self.grab_pages(self.grab_urls).map do |page|
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
          :headliner => headlinerNode == nil ? "" : headlinerNode.text,
          :support   => supportNode == nil ?   [] : supportNode.text.split(",")
        }
      end
    end
    events.flatten.compact
  end
end
