This is a test

Empty state

  $ $TESTDIR/layout.rb ""
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |

  $ $TESTDIR/layout.rb Hello
  |Hello                |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |


Text wrapping

  $ $TESTDIR/layout.rb "Hello World Hello World Hello World Hello World"
  |Hello World Hello    |
  |                     |
  |World Hello World    |
  |                     |
  |Hello World          |
  |                     |
  |                     |
  |                     |

Text scrolling

  $ $TESTDIR/layout.rb "Hello World Hello World Hello World Hello World. Long text. Long text. Long text. Long text. Long text. Done"
  |text. Long text. Long|
  |                     |
  |text. Done           |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |

Make sure we don't go to next page until current one filled up

  $ $TESTDIR/layout.rb $(ruby -e 'puts "X" * 84')
  |XXXXXXXXXXXXXXXXXXXXX|
  |                     |
  |XXXXXXXXXXXXXXXXXXXXX|
  |                     |
  |XXXXXXXXXXXXXXXXXXXXX|
  |                     |
  |XXXXXXXXXXXXXXXXXXXXX|
  |                     |

Newline starts new page

  $ $TESTDIR/layout.rb "$(echo "Hello\nWorld")"
  |World                |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |

Newline clears the screen

  $ echo "Hello\n" | xargs -0 $TESTDIR/layout.rb
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
