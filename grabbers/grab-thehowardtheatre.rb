require_relative "../grabber-base"

class Grabber < GrabberBase
  # get the array of urls to grab from
  def self.grab_urls
    # The url that list all the shows
    [
      "http://thehowardtheatre.com/calendar/"
    ]
  end
  # Go through each url to get the shows
  def self.shows
    # The layout is crazy !? (uses fullcalendar)
    events = self.grab_pages(self.grab_urls).map do |page|
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      page.search("a.fc-event").map do |elem|
        # TODO: Grab the date from the column?
        # Grab date from the href it looks like the format of "{url}/show/YYYY/MM/DD/{rest of url}"
        href = elem["href"]
        # no link, then no date
        next if href.nil?
        href.strip!
        # if no "show" then it is a private event
        next unless href.include?("show")
        # make sure there is a date
        match = href.match(/[[:digit:]]+\/[[:digit:]]+\/[[:digit:]]+/)[0]
        next if match.nil?
        # convert the date so we can see the year
        date = convert_date(match)

        # grab the rest of the information
        headlinerNode = elem.at(".headliner")
        # grab the siblings after the headliner element
        supportNode   = elem.at(".headliner ~ small")

        # create the show object
        {
          :venue     => "The Howard Theatre",
          :date      => date,
          :headliner => headlinerNode == nil ? "": headlinerNode.text,
          :support   => supportNode == nil ?   [] : supportNode.text.split(",")
        }
      end
    end
    events.flatten.compact
  end
end
