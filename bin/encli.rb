#!/usr/bin/env ruby
#
# A basic command line client for the Enc module.
#
# This software is licensed under the Creative
# Commons CC0 1.0 Universal License.
# To view a copy of this license, visit
# http://creativecommons.org/publicdomain/zero/1.0/legalcode
#
# @author Patrick Hof

require File.join(File.dirname(__FILE__), '..', 'lib', 'enc')

help_text = [
  "",
  "Available Encoders",
  "------------------"
]
Enc.constants.sort.each do |c|
  Enc.const_get(c).singleton_methods.sort.each do |m|
    help_text << "#{c}::#{m}"
  end
end
help_text += [
  "",
  "Usage: #{__FILE__} <encoder> [params] <string from stdin>",
  "",
  "Examples:",
  "#{__FILE__} Std::url <<< '<script>'",
  "#{__FILE__} Std::url true <<< '<script>'",
  "",
  "Please see the YARD documentation for available parameters.",
  "",
  ""
]
# Show help
if ARGV[0] == "-h"
  puts help_text.join("\n")
# Run encoder 
else
  begin
    mod, m = ARGV[0].split("::")
    params = ARGV[1] ? ARGV[1].split(",") : []
    puts Enc.const_get(mod.to_sym).send(m.to_sym, $stdin.read(), *params)
  rescue Exception => e
    puts "ERROR: #{e}"
    puts help_text.join("\n")
  end
end
