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
  def reconcile(from, to, &block)
    raise "Sizes differ #{from.size} != #{to.size}" if from.size != to.size
    to.each_char.with_index do |char, index|
      block.call(char, index) if from[index] != char
    end
  end
end

if __FILE__ == $0

  message = ""
  shift = false

  exec "/usr/sbin/oled-exp", "-i", "dim", "on"
  trap("SIGINT") do
    exec "/usr/sbin/oled-exp", "-c"
    exit!
  end

  dev = File.open(DEVICE, 'rb')
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

    row = message.length / 20
    col = message.length % 20

    if letter == :backspace
      message.chop!
      letter = ' '
    end

    exec "/usr/sbin/oled-exp", "cursor", "#{row * 2},#{col}", "write", letter
  end

end
