app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant G: single direct recursive payload (not through List)
# The simplest possible case: do we need List wrapping for ANY recursive payload?
Chain := [End, Link(Chain)]

length : Chain -> I64
length = |c|
    match c {
        End => 0
        Link(rest) => 1 + length(rest)
    }

main! = || {
    chain : Chain
    chain = Link(Link(Link(End)))
    l = length(chain)
    Stdout.line!("length: ${l.to_str()}")
}
