#!/usr/bin/env ruby

class Reconciler
  def reconcile(from, to, &block)
    raise Error.new("Sizes differ #{from.size} != #{to.size}") if from.size != to.size
    to.each_char.with_index do |char, index|
      block.call(char, index) if from[index] != char
    end
  end
end

if __FILE__ == $0
  rc = Reconciler.new
  rc.reconcile(ARGV[0], ARGV[1]) do |char, index|
    puts "Put <#{char}> at #{index}"
  end
end
