# META
~~~ini
description=Regression test: dot-access dispatch with multiple arguments should not read stale monotype slice data when argument lowering triggers backing array reallocation in Lower.zig lowerDotAccess
type=snippet
~~~
# SOURCE
~~~roc
items : List(I64)
items = [10, 20, 30]

sum = items.walk(0, |state, x| state + x)

expect sum == 60
~~~
# EXPECTED
NIL
# PROBLEMS
NIL
