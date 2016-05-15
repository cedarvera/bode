#!/usr/bin/env ruby

require "thread"
require "json"

FOLDER = "grabbers"
threads = []
shows = []

# go through each grabber script in the grabbers folder and grab the shows
Dir.foreach(FOLDER) do |file|
  next unless file =~ /[[:word:]]/
  # Start a thread for each grabber
  threads << Thread.new {
    # dynamically load and run the grab script to get the shows from the website
    mod = Module.new
    load "#{FOLDER}/#{file}"
    mod.const_set("Grabber", Grabber)
    Object.send(:remove_const, :Grabber)
    shows.concat(mod::Grabber.new.get_shows)
  }
  # restrict to only running 5 at a time
  if threads.size >= 5
    threads.each { |thread| thread.join }
    threads = []
  end
end

# wait until last of the threads are done
threads.each { |thread| thread.join }

json = shows.to_json
timestamp = Time.now.strftime("%Y-%m-%d-%H-%M-%s")

File.open("#{timestamp}.json", "w") { |file| file.puts(json) }
