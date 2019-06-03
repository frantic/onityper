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

SHIFT_LINE = <<-END
` ~ 1 ! 2 @ 3 # 4 $ 5 % 6 ^ 7 & 8 * 9 ( 0 ) - _ = + [ { ] } \\ | , < . > / ? ; : ' "
END
SHIFT_KEYS = Hash[*SHIFT_LINE.split(' ')]

FILE_NAME = "/root/notes/" + Time.new.strftime("%Y-%m-%d_%H.%M.%S.txt")

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
    last_newline = text.rindex("\n")
    text = text[(last_newline + 1)..-1] if last_newline

    page_size = @width * @height / 2
    pages_count = text.size / page_size
    last_page_start = pages_count * page_size
    last_page_start -= page_size if text.size > 0 && text.size % page_size == 0
    text = text[last_page_start..-1]

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
    row = 0
    col = 0
    text = ""
    to.each_char.with_index do |char, index|
      if from[index] == char
        unless text.empty?
          block.call(row, col, text)
          text = ""
        end
      else
        if text.empty?
          row = index / @width
          col = index % @width
        end
        text << char
      end
    end
    block.call(row, col, text) unless text.empty?
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
      if shift
        letter = SHIFT_KEYS[letter.to_s] || letter.to_s.upcase
      else
        letter = letter.to_s.downcase
      end
      message << letter
    end

    if letter == :backspace
      message.chop!
    end

    if letter == :enter
      message << "\n"
      File.write(FILE_NAME, message)
    end

    next_screen = layout.render(message)
    reconciler.reconcile(prev_screen, next_screen) do |row, col, text|
      oled_command "cursor", "#{row},#{col}", "write", text
    end
    prev_screen = next_screen
  end
end
