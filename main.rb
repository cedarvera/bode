#!/usr/bin/env ruby

require "json"

FOLDER = "grabbers"
threads = []
shows = []

# go through each grabber script in the grabbers folder and grab the shows
Dir.foreach(FOLDER) do |file|
  next unless file =~ /[[:word:]]/
  # dynamically load and run the grab script to get the shows from the website
  mod = Module.new
  load "#{FOLDER}/#{file}"
  mod.const_set("Grabber", Grabber)
  Object.send(:remove_const, :Grabber)
  begin
    mod::Grabber.new.get_shows do |new_shows|
      shows << new_shows
    end
  rescue Capybara::Poltergeist::StatusFailError
    puts("#{file}: site possibly down")
  end
end

json = shows.to_json
timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%s")

File.open("#{timestamp}.json", "w") { |file| file.puts(json) }
