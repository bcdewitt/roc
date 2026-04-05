app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant J: End (no payload) + List wrapping + List.fold
# Tests whether it's the no-payload base case or the List.first pattern
Chain := [End, Link(List(Chain))]

length : Chain -> I64
length = |c|
    match c {
        End => 0
        Link(children) =>
            List.fold(children, 1, |acc, child| acc + length(child))
    }

main! = || {
    chain : Chain
    chain = Link([End, End])
    l = length(chain)
    Stdout.line!("length: ${l.to_str()}")
}
