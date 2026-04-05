app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# A very simple recursive function on Chain (via List)
depth : Chain -> I64
depth = |c|
    match c {
        End => 0
        Link(children) =>
            1
    }

main! = || {
    Stdout.line!("before")
    c : Chain
    c = End
    d = depth(c)
    Stdout.line!("depth: ${d.to_str()}")
}
