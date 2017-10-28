#!/usr/bin/env ruby

require "optparse"
require "json"

FOLDER = "scrapers"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options] SCRAPER"

  opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| options[:verbose] = v }

end.parse!
# get the scraper to run
scraper = ARGV[0]

shows = []
# load a specific scraper script in the scrapers folder and grab the shows
path = "#{FOLDER}/#{scraper}.rb"
# make sure it is a file
return unless File.file?(path)
# dynamically load and get the shows from the website
mod = Module.new
puts("loading #{path}") if options[:verbose]
load path
mod.const_set("Scraper", Scraper)
Object.send(:remove_const, :Scraper)
begin
  puts("grabbing") if options[:verbose]
  mod::Scraper.new.grab_shows do |new_shows|
    shows << new_shows
  end
  puts("done") if options[:verbose]
rescue Selenium::WebDriver::Error::UnknownError => error
  puts("#{scraper}: site possibly down")
  puts(error.message)
  puts(error.backtrace)
end

json = shows.to_json
timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%s")

File.open("#{timestamp}.#{scraper}.json", "w") { |file| file.puts(json) }
