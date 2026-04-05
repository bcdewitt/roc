app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Single-field recursive with I64 instead of self
# This isolates single-arg path vs multi-arg path
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
    Stdout.line!("length: ${length(chain).to_str()}")
}
