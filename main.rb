#!/usr/bin/env ruby

require "pp"

folder = "grabbers"
shows = []

# go through each grabber script in the grabbers folder and grab the shows
Dir.foreach(folder) do |file|
  next unless file =~ /[[:word:]]/
  # dynamically load and run the grab script to get the shows from the website
  mod = Module.new
  load "#{folder}/#{file}"
  mod.const_set("Grabber", Grabber)
  Object.send(:remove_const, :Grabber)
  shows << mod::Grabber.shows
end

PP.pp(shows)
