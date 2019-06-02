Reconciler is responsible for finding differences in texts and printing operations
to bring the screen from state1 to state2

  $ $TESTDIR/reconciler.rb Hello Hello

  $ $TESTDIR/reconciler.rb Test Jest
  Put <J> at 0

  $ $TESTDIR/reconciler.rb "Very long string" "Bery isnt corect"
  Put <B> at 0
  Put <i> at 5
  Put <s> at 6
  Put <t> at 8
  Put <c> at 10
  Put <o> at 11
  Put <e> at 13
  Put <c> at 14
  Put <t> at 15
