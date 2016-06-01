require_relative "../grabber_base"

class Grabber < GrabberBase
  # constructor
  def initialize
    # The url that list all the shows
    @urls = [
      "http://dcnine.com/calendar/"
    ]
  end
  # Go through the page and find the the shows
  def find_shows
    @urls.map do |url|
      visit(url)
      # Looks like it is consistent in layout
      # so grab what we need
      events = []
      event = {}
      # shows are in #content div
      all("#content > *").each do |node|
        # h2 holds the headliner a["title"] (it has two duplicates)
        if node.tag_name === "h2"
          event[:headliner] = node.first("a")[:title].strip
        # h3 holds the support
        # it appears to be broken to multiple strong nodes
        elsif node.tag_name === "h3"
          supports =[]
          node.all("strong").each do |support|
            text = support.text.strip
            if not text.empty?
              supports.push(text)
            end
          end
          event[:support] = supports
        # p holds the date
        # it appears to be broken to multiple strong nodes
        elsif node.tag_name === "p"
          # the first child appears to be the date
          event[:date] = convert_date(node.first("strong").text.strip)
          # this is for DC9
          event[:venue] = "DC9"
          # it is also the last node before the next show group
          events.push(event)
          event = {}
        end
        # and repeats
      end
      yield(events.compact.flatten, page.html)
    end
  end
end
