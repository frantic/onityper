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

system "oled-exp -i dim on"

trap("SIGINT") do
  system "oled-exp -c"
  exit!
end

message = ""
shift = false

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

  system "oled-exp cursor #{row * 2},#{col} write '#{letter}'"
end

