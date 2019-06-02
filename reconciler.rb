#!/usr/bin/env ruby

require_relative 'onityper'

if __FILE__ == $0
  rc = Reconciler.new(5, 5)
  rc.reconcile(ARGV[0], ARGV[1]) do |row, col, char|
    puts "Put <#{char}> at #{row}:#{col}"
  end
end
