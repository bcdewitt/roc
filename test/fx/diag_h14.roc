app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# Does the recursion work when the recursive arg comes from a basic match (not List.first)?
recurse_simple : Chain -> I64
recurse_simple = |c|
    match c {
        End => 0
        Link(rest) => 1 + recurse_simple(rest.first().ok_or(End))
    }

main! = || {
    Stdout.line!("before")
    c : Chain
    c = End
    n = recurse_simple(c)
    Stdout.line!("result: ${n.to_str()}")
}
