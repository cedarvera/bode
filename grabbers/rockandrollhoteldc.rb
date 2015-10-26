require "mechanize"

mechanize = Mechanize.new
# Say I am a robot
mechanize.robots = true
# The url that list all the shows
pagesUrl = [
  "http://www.rockandrollhoteldc.com/"
]
# Go through each url to get the shows
shows = pagesUrl.map do |url|
  # Get the page
  page = mechanize.get(url)
  # Looks like it is consistent in the classes it uses
  # so grab what we need
  page.search(".entry-content-live").map do |elem|
    # uhall has the same format as 930's website
    headlinerNode = elem.at(".artist_title a")
    # check if headline is there.
    headline = headlinerNode == nil ? "" : headlinerNode.text.strip

    dateNode = elem.at(".artist_date")
    # convert the date so we can see the year
    date = Date.today
    if dateNode != nil
      # it is delimited by '|' and the date is on the first index
      date = Date.parse(dateNode.text.strip.split("|")[0])
      # if its parsed to be before today then its in actual the following year
      if date < Date.today
        date = date.next_year()
      end
    end
    # openers are delimited by '|'
    supports = []
    supportsNode = elem.at(".openers")
    if supportsNode != nil
      supports = supportsNode.text.strip.split("|").map do |support|
        support.strip
      end
    end
    # create the show object
    {
      :venue     => "Rock & Roll Hotel",
      :date      => date,
      :headliner => headline,
      :support   => supports
    }
  end
end

p(shows)
