This is a test

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
  |World. Long text. Lon|
  |                     |
  |g text. Long text. Lo|
  |                     |
  |ng text. Long text. D|
  |                     |
  |one                  |
  |                     |
