#!/usr/bin/env ruby

require_relative 'onityper'

if __FILE__ == $0
  rc = Reconciler.new
  rc.reconcile(ARGV[0], ARGV[1]) do |char, index|
    puts "Put <#{char}> at #{index}"
  end
end
