#!/usr/bin/env ruby

require "optparse"
require "json"

FOLDER = "scrapers"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") { |v| options[:verbose] = v }

end.parse!

shows = []
# go through each scraper script in the scrapers folder and grab the shows
Dir.foreach(FOLDER) do |file|
  path = "#{FOLDER}/#{file}"
  # make sure it is a file with extension "rb"
  next unless File.file?(path) && file =~ /[[:word:]]\.rb/
  # dynamically load and get the shows from the website
  mod = Module.new
  puts("loading #{path}") if options[:verbose]
  load path
  mod.const_set("Scraper", Scraper)
  Object.send(:remove_const, :Scraper)
  #begin
    puts("grabbing") if options[:verbose]
    mod::Scraper.new.grab_shows do |new_shows|
      shows << new_shows
    end
    puts("done") if options[:verbose]
  #rescue Capybara::Selenium::StatusFailError
  #  puts("#{file}: site possibly down")
  #end
end

json = shows.to_json
timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%s")

File.open("#{timestamp}.json", "w") { |file| file.puts(json) }
