DEVICE = '/dev/input/event0'

EV_KEY = 1

V_RELEASE = 0
V_PRESS = 1
V_REPEAT = 2

KEYS = [
  :reserved,
  :esc, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?0, ?-, ?=, :backspace,
  :tab, ?Q, ?W, ?E, ?R, ?T, ?Y, ?U, ?I, ?O, ?P, ?[, ?], :enter,
  :ctrl, ?A, ?S, ?D, ?F, ?G, ?H, ?J, ?K, ?L, ?;, ?', ?`,
  :shift, ?\\, ?Z, ?X, ?C, ?V, ?B, ?N, ?M, ?,, ?., ?/, :shift, :asterisk,
  :alt, ' ', :capslock,
  :f1, :f2, :f3, :f4, :f5, :f6, :f7, :f8, :f9, :f10, 
]

def oled_command(*args)
  Process.wait(fork { exec("/usr/sbin/oled-exp", "-q", *args) })
end

class TextLayout
  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
  end

  def render(text)
    res = []
    row = 0
    while text.length > 0 || row < @height || row % 2 == 1
      if row % 2 == 1
        res << " " * @width
      else
        res << text[0...@width].ljust(@width)
        text = text[@width..-1] || ""
      end
      row += 1
    end
    res.last(@height).join
  end
end


class Reconciler
  def initialize(width, height)
    @width = width
    @height = height
  end

  def reconcile(from, to, &block)
    raise "Sizes differ #{from.size} != #{to.size}" if from.size != to.size
    to.each_char.with_index do |char, index|
      if from[index] != char
        row = index / @width
        col = index % @width
        block.call(row, col, char)
      end
    end
  end
end

if __FILE__ == $0
  layout = TextLayout.new(21, 8)
  reconciler = Reconciler.new(21, 8)
  message = ""
  shift = false
  prev_screen = layout.render(message)

  
  oled_command "-i", "dim", "on"
  trap("SIGINT") do
    oled_command "-c"
    exit!
  end

  dev = File.open(DEVICE, 'rb')
  puts dev
  while data = dev.read(16)
    time, type, code, value = data.unpack("QSSL")
    letter = KEYS[code]

    next unless type == EV_KEY

    if letter == :shift
      shift = value == V_PRESS || value == V_REPEAT
      next
    end

    next unless value == V_PRESS || value == V_REPEAT

    next unless letter

    if letter.to_s.length == 1
      letter = shift ? letter.to_s.upcase : letter.to_s.downcase
      message += letter
    end

    if letter == :backspace
      message.chop!
      letter = ' '
    end

    next_screen = layout.render(message)
    reconciler.reconcile(prev_screen, next_screen) do |row, col, char|
      oled_command "cursor", "#{row},#{col}", "write", char
    end
    prev_screen = next_screen
  end
end
