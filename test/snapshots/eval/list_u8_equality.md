# META
~~~ini
description=Regression test: List(U8) equality comparison fails in dev backend when list_get_unsafe stores only elem_size bytes, leaving dirty upper bytes that corrupt qword comparison
type=snippet
~~~
# SOURCE
~~~roc
a : List(U8)
a = [1, 2, 3]

b : List(U8)
b = [1, 2, 3]

c : List(U8)
c = [1, 2, 4]

expect a == b
expect a != c
~~~
# EXPECTED
NIL
# PROBLEMS
NIL
