#!/usr/bin/env ruby

require_relative 'onityper'

if __FILE__ == $0
  tl = TextLayout.new(21, 8)
  output = tl.render(ARGV.first)

  tl.height.times { |row| 
    from, to = row * tl.width, (row + 1) * tl.width
    puts "|" + output[from...to] + "|"
  }
end
