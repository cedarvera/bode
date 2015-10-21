require "mechanize"

mechanize = Mechanize.new
# Say I am a robot
mechanize.robots = true
# The url that list all the shows
pagesUrl = [
  "http://www.blackcatdc.com/schedule.html"
]
# Go through each url to get the shows
shows = pagesUrl.map do |url|
  # Get the page
  page = mechanize.get(url)
  # Looks like it is consistent in the classes it uses
  # so grab what we need
  page.search(".show-details").map do |elem|
    # uhall has the same format as 930's website
    headlinerNode = elem.at(".headline a")
    # check if headline is there.
    headline = headlinerNode == nil ? "" : headlinerNode.text
    # if its empty then its at the Upcoming which we can skip
    next if headline.empty?

    dateNode = elem.at(".date")
    # convert the date so we can see the year
    date = Date.today
    if dateNode != nil and not dateNode.text.empty?
      date = Date.parse(dateNode.text)
      # if its parsed to be before today then its in actual the following year
      if date < Date.today
        date = date.next_year()
      end
    end
    # the supports are in their own nodes!
    support = elem.search(".support").map do |sup|
      sup.text.strip
    end
    # create the show object
    {
      :venue     => "Black Cat",
      :date      => date,
      :headliner => headline,
      :support   => support
    }
  end
end

p(shows)
