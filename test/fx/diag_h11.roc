app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# Simple recursion through List.fold (no List.first)
count : Chain -> I64
count = |c|
    match c {
        End => 1
        Link(children) => children.fold(0, |acc, child| acc + count(child))
    }

main! = || {
    Stdout.line!("before")
    c : Chain
    c = End
    n = count(c)
    Stdout.line!("count: ${n.to_str()}")
}
