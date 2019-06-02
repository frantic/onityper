#!/usr/bin/env ruby

require_relative 'onityper'

class TextLayout
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  def render(text)
    res = ""
    height.times do
      res += text[0...@width].ljust(@width)
      text = text[@width..-1] || ""
    end
    res
  end
end

tl = TextLayout.new(21, 8)
output = tl.render(ARGV.first)

tl.height.times { |row| 
  from, to = row * tl.width, (row + 1) * tl.width
  puts "|" + output[from...to] + "|"
}
