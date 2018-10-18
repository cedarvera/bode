require 'date'
require 'nokogiri'
require "capybara/dsl"

# to differentiate from the dsl commands prefix with grab
class ScraperBase
  include Capybara::DSL
  # constructor. get the options such as verbosity
  def initialize(options)
    @is_verbose = options[:verbose]
    @rainbow = options[:colorize]
  end
  # attempt to get the text of an element, else return the default
  def grab_text(elem, selector, default)
    node = elem.at(selector)
    return default if node.nil?
    text = node.text.strip
    case default
    when String then text
    when Array then text.split(",").map { |t| t.strip }
    when Date then convert_date(text)
    else
      default
    end
  end
  # attempt to get the texts of multiple elements, else return an array of defaults
  def grab_texts(elem, selector, default)
    arr = []
    elem.search(selector).map do |node|
      next if node.nil?
      text = node.text.strip
      case default
      when String then arr << text
      when Date then arr << convert_date(text)
      else
        arr << default
      end
    end
    arr
  end
  # Go through each url to get the shows
  def grab_shows
    grab_pages do |html|
      shows = find_shows(Nokogiri::HTML(html)).flatten.compact
      if @is_verbose and not shows.nil?
        shows.each do |show|
          colors = [ :lavender, :salmon, :turquoise, :mediumspringgreen, :peachpuff, :aquamarine ]
          date = @rainbow.wrap("#{show[:date]}").underline
          headliner = @rainbow.wrap(show[:headliner]).gold
          support = show[:support].map do |sup|
            @rainbow.wrap(sup).color(colors.rotate![0])
          end
          puts("#{date}\t#{headliner}\t#{support.join("\t")}")
        end
      end
      yield({
        html: html,
        shows: shows
      })
    end
  end
  # convert the date text into the date of the show
  def convert_date(text)
    date = Date.parse(text)
    # if its parsed to be before today then its in usually the following year
    return date.next_year if date < Date.today
    # return date
    date
  rescue
    # use today if not parsable
    Date.today
  end
end
