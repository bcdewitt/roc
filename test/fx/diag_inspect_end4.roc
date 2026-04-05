app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Test: does passing End to a function work, even with a box-layout scrutinee?
Chain := [End, Link(Chain)]

# This function works (our fix handles box scrutinee)
match_chain : Chain -> Str
match_chain = |c|
    match c {
        End => "end"
        Link(_) => "link"
    }

# What if we wrap in another function that also matches?
describe_inner : Chain -> Str
describe_inner = |c|
    match c {
        End => "inner-end"
        Link(_) => "inner-link"
    }

# What about matching on a locally-bound inspect-like pattern?
fake_inspect : Chain -> Str
fake_inspect = |c|
    match c {
        End => "End"
        Link(inner) => "Link(${fake_inspect(inner)})"
    }

main! = || {
    chain : Chain
    chain = End
    Stdout.line!(match_chain(chain))
    Stdout.line!(describe_inner(chain))
    Stdout.line!(fake_inspect(chain))
}
