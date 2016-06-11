require_relative "../grabber_base"

class Grabber < GrabberBase
  # get the pages and return the resulting html
  def grab_pages
    visit("http://www.blackcatdc.com/schedule.html")
    yield(page.html)
  end
  # Go through the page and find the the shows
  def find_shows(page)
    # Looks like it is consistent in the classes it uses
    # so grab what we need
    page.search(".show-details").map do |elem|
      headliners = elem.search(".headline a").map do |headliner|
        headliner.text.strip
      end
      # if its empty then its at the Upcoming which we can skip
      next if headliners.empty?

      dateNode = elem.at(".date")
      # convert the date so we can see the year
      date = Date.today
      if not dateNode.nil? and not dateNode.text.empty?
        date = convert_date(dateNode.text)
      end
      # the supports are in their own nodes!
      support = elem.search(".support").map do |sup|
        sup.text.strip
      end
      # create the show object
      {
        :venue     => "Black Cat",
        :date      => date,
        :headliner => headliners.first,
        :support   => headliners.drop(1) + support
      }
    end
  end
end
