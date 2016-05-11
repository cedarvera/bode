require_relative "../grabber-base"

class Grabber < GrabberBase
  # constructor
  def initialize
    @urls = [
      "http://www.rockandrollhoteldc.com/"
    ]
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".entry-content-live").map do |elem|
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
end
