app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant I: Chain with End(I64) payload and List wrapping
# Matches working tree pattern more closely (base case has payload)
Chain := [End(I64), Link(List(Chain))]

length : Chain -> I64
length = |c|
    match c {
        End(_) => 0
        Link(children) =>
            List.fold(children, 1, |acc, child| acc + length(child))
    }

main! = || {
    chain : Chain
    chain = Link([End(1), End(2)])
    l = length(chain)
    Stdout.line!("length: ${l.to_str()}")
}
