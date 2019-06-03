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
  |Hello World Hello Wor|
  |                     |
  |ld Hello World Hello |
  |                     |
  |World                |
  |                     |
  |                     |
  |                     |

Text scrolling

  $ $TESTDIR/layout.rb "Hello World Hello World Hello World Hello World. Long text. Long text. Long text. Long text. Long text. Done"
  |ng text. Long text. D|
  |                     |
  |one                  |
  |                     |
  |                     |
  |                     |
  |                     |
  |                     |
