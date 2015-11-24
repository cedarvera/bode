require_relative 'grabber'

class GrabDC9 < Grabber
  # get the array of urls to grab from
  def grab_urls
    # The url that list all the shows
    [
      "http://dcnine.com/calendar/"
    ]
  end
  # Go through each url to get the shows
  def shows
    self.grab_pages(self.grab_urls).map do |page|
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
          event[:date] = self.convert_date(node.first_element_child.text.strip)
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
  end
end

p(GrabDC9.new.shows)
