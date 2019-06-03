Reconciler is responsible for finding differences in texts and printing operations
to bring the screen from state1 to state2

  $ $TESTDIR/reconciler.rb Hello Hello

  $ $TESTDIR/reconciler.rb Test Jest
  Put <J> at 0:0

  $ $TESTDIR/reconciler.rb "AAAA Test 1" "BBBB Test 2"
  Put <BBBB> at 0:0
  Put <2> at 2:0

  $ $TESTDIR/reconciler.rb "Very long string" "Bery isnt corect"
  Put <B> at 0:0
  Put <is> at 1:0
  Put <t> at 1:3
  Put <co> at 2:0
  Put <ect> at 2:3
