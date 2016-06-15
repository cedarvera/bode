#!/usr/bin/env ruby

require "json"

FOLDER = "scrapers"
threads = []
shows = []

# go through each scraper script in the scrapers folder and grab the shows
Dir.foreach(FOLDER) do |file|
  path = "#{FOLDER}/#{file}"
  # make sure it is a file with extension "rb"
  next unless File.file?(path) && file =~ /[[:word:]]\.rb/
  # dynamically load and get the shows from the website
  mod = Module.new
  load path
  mod.const_set("Scraper", Scraper)
  Object.send(:remove_const, :Scraper)
  begin
    mod::Scraper.new.grab_shows do |new_shows|
      shows << new_shows
    end
  rescue Capybara::Poltergeist::StatusFailError
    puts("#{file}: site possibly down")
  end
end

json = shows.to_json
timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%s")

File.open("#{timestamp}.json", "w") { |file| file.puts(json) }
