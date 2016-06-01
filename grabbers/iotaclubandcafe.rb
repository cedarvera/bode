require_relative "../grabber_base"

class Grabber < GrabberBase
  # constructor
  def initialize
    @urls = [
      "http://www.iotaclubandcafe.com/start/sched_cur.asp"
      #"http://www.iotaclubandcafe.com/"
    ]
  end
  # Go through the page and find the the shows
  def find_shows
    @urls.map do |url|
      visit(url)
      events = []
      # Looks like it is consistent in layout
      # so grab what we need
      # shows are table in div with id contentCont
      all("body > *").each do |node|
        # default to today
        curdate = Date.today

        # the first h1 encountered is the current month and year
        if node.tag_name === "h1"
          # it is split with a space (as &nbsp;) with month first and year second
          #firstdate = node.text.strip.split(/[[:space:]]/)
          #curmonth = firstdate[0]
          #curyear = firstdate[1].to_i
          curdate = Date.parse(node.text.strip)

        # the table is where there the shows are
        elsif node.tag_name === "table"
          # the switch to phantomjs gives the table a tbody
          node.all("tbody > *").each do |row|
            # make sure the row is populated, skip to next if not
            next if row.text === ""
            # There are two visible types of row, one is the show and the other is the next month
            # there is a hidden one of length 3
            nodes = row.all("td").map { |cell| cell }
            # the date row
            if nodes.length == 1
              # see if there is a h1 (which would be the month)
              nodes[0].all("h1").each do |newMonth|
                # update the month (it might skip months)
                nextdate = Date.parse("#{newMonth.text} #{curdate.year}")
                # if it is less then current saved date more then likely it went to the next year
                if nextdate < curdate
                  nextdate = nextdate.next_year
                end
                curdate = nextdate
              end

            # the show row
            elsif nodes.length == 5
              # The first two cells is the date
              # we only care about the second (the day its on)
              day = nodes[1].text.strip.to_i
              # set the current date
              curdate = Date.new(curdate.year, curdate.month, day)
              # Third is the artists populated in divs
              supports = []
              nodes[2].all("div").each do |support|
                supports.push(support.text.strip)
              end
              # fourth is the time and cost, we can ignore

              events.push({
                :venue => "Iota Club & Cafe",
                :date => curdate,
                # assume the first is the headliner
                :headliner => supports.first,
                :support => supports.drop(1)
              })
            end
          end
        end
      end
      yield(events.flatten.compact, page.html)
    end
  end
end
