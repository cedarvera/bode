require_relative "grabber"

class GrabBlackCatDC < Grabber
  # get the array of urls to grab from
  def grab_urls
    # The url that list all the shows
    [
      "http://www.blackcatdc.com/schedule.html"
    ]
  end
  # Go through each url to get the shows
  def shows
    self.grab_pages(self.grab_urls).map do |page|
      # Looks like it is consistent in the classes it uses
      # so grab what we need
      page.search(".show-details").map do |elem|
        headlinerNode = elem.at(".headline a")
        # check if headline is there.
        headline = headlinerNode == nil ? "" : headlinerNode.text
        # if its empty then its at the Upcoming which we can skip
        next if headline.empty?

        dateNode = elem.at(".date")
        # convert the date so we can see the year
        date = Date.today
        if dateNode != nil and not dateNode.text.empty?
          date = self.convert_date(dateNode.text)
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
  end
end

p(GrabBlackCatDC.new.shows)
