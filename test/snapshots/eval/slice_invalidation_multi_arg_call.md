# META
~~~ini
description=Regression test: multi-argument function calls should not read stale monotype slice data when argument lowering triggers backing array reallocation in Lower.zig lowerCallWithLoweredFunc
type=snippet
~~~
# SOURCE
~~~roc
apply3 : (I64 -> I64), (I64 -> I64), (I64 -> I64), I64 -> I64
apply3 = |f, g, h, x| h(g(f(x)))

result = apply3(|n| n + 1, |n| n * 2, |n| n - 3, 10)

expect result == 19
~~~
# EXPECTED
NIL
# PROBLEMS
NIL
