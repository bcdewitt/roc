app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant C: List(Str) return, non-recursive (no nominal type)
# Tests whether List(Str) returns are broken in general or only with recursion

get_strs : I64 -> List(Str)
get_strs = |n|
    if n <= 0
        []
    else
        List.concat(get_strs(n - 1), [n.to_str()])

main! = || {
    result = get_strs(3)
    Stdout.line!(Str.join_with(result, " "))
}
