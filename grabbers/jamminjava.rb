require "mechanize"

mechanize = Mechanize.new
# Say I am a robot
mechanize.robots = true
# The url that list all the shows
pagesUrl = [
  "http://jamminjava.com/calendar"
]
# Go through each url to get the shows
shows = pagesUrl.map do |url|
  # Get the page
  page = mechanize.get(url)
  # Looks like it is consistent in the classes it uses
  # so grab what we need
  page.search(".vevent").map do |elem|
    # uhall has the same format as 930's website
    headlinerNode = elem.at(".headliners a")
    supportNode   = elem.at(".supports a")
    dateNode      = elem.at(".dates")
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
      :venue     => "Jammin' Java",
      :date      => date,
      :headliner => headlinerNode == nil ? "" : headlinerNode.text,
      :support   => supportNode == nil ?   [] : supportNode.text.split(",")
    }
  end
end

p(shows)
