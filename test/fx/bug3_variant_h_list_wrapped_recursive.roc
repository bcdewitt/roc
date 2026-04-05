app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant H: single recursive payload through List — should WORK
Chain := [End, Link(List(Chain))]

length : Chain -> I64
length = |c|
    match c {
        End => 0
        Link(rest) =>
            match List.first(rest) {
                Ok(next) => 1 + length(next)
                Err(_) => 0
            }
    }

main! = || {
    chain : Chain
    chain = Link([Link([Link([End])])])
    l = length(chain)
    Stdout.line!("length: ${l.to_str()}")
}
