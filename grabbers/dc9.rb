require "mechanize"

mechanize = Mechanize.new
# Say I am a robot
mechanize.robots = true
# The url that list all the shows
pagesUrl = [
  "http://dcnine.com/calendar/"
]
# Go through each url to get the shows
shows = pagesUrl.map do |url|
  # Get the page
  page = mechanize.get(url)
  # Looks like it is consistent in layout
  # so grab what we need
  events = []
  event = {}
  # shows are in #content div
  page.at("#content").children().each do |node|
    # h2 holds the headliner a["title"] (it has two duplicates)
    if node.name == "h2"
      event[:headliner] = node.first_element_child["title"].strip
    # h3 holds the support
    # it appears to be broken to multiple strong nodes
    elsif node.name == "h3"
      supports =[]
      node.children().each do |support|
        if support.element? and not support.comment?
          text = support.text.strip
          if not text.empty?
            supports.push(text)
          end
        end
      end
      event[:support] = supports
    # p holds the date
    # it appears to be broken to multiple strong nodes
    elsif node.name == "p"
      # the first child appears to be the date
      date = Date.parse(node.first_element_child.text.strip)
      # if its parsed to be before today then its in actual the following year
      if date < Date.today
        date = date.next_year()
      end
      event[:date] = date
      # this is for DC9
      event[:venue] = "DC9"
      # it is also the last node before the next show group
      events.push(event)
      event = {}
    end
    # and repeats
  end
  events
end

p(shows)
