#!/usr/bin/env ruby

require_relative '../onityper'

if __FILE__ == $0
  rc = Reconciler.new(5, 5)
  rc.reconcile(ARGV[0], ARGV[1]) do |row, col, text|
    puts "Put <#{text}> at #{row}:#{col}"
  end
end
