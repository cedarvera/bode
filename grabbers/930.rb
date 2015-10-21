require "mechanize"

mechanize = Mechanize.new
# Say I am a robot
mechanize.robots = true
# The url that list all the shows
pagesUrl = [
  "http://www.930.com/concerts/",
  "http://www.930.com/concerts/merriweather/",
  "http://www.930.com/concerts/lincoln-theatre/",
  "http://www.930.com/concerts/imp/"
]
# Go through each url to get the shows
shows = pagesUrl.map do |url|
  # Get the page
  page = mechanize.get(url)
  # Looks like it is consistent in the classes it uses
  # so grab what we need
  page.search(".vevent").map do |elem|
    headlinerNode = elem.at(".headliners a")
    supportNode   = elem.at(".supports a")
    dateNode      = elem.at(".dates")
    venueNode     = elem.at(".venue")
    # convert the date so we can see the year
    date = Date.today
    if dateNode != nil
      date = Date.parse(dateNode.text)
      # if its parsed to be before today then its in actual the following year
      if date < Date.today
        date = date.next_year()
      end
    end
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

p(shows)
