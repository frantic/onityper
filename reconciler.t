Reconciler is responsible for finding differences in texts and printing operations
to bring the screen from state1 to state2

  $ $TESTDIR/reconciler.rb Hello Hello

  $ $TESTDIR/reconciler.rb Test Jest
  Put <J> at 0:0

  $ $TESTDIR/reconciler.rb "Very long string" "Bery isnt corect"
  Put <B> at 0:0
  Put <i> at 1:0
  Put <s> at 1:1
  Put <t> at 1:3
  Put <c> at 2:0
  Put <o> at 2:1
  Put <e> at 2:3
  Put <c> at 2:4
  Put <t> at 3:0
