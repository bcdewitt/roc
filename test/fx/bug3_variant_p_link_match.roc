app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant P: Use Link(End) and match (construct recursive value, no inspect)
Chain := [End, Link(Chain)]

describe : Chain -> Str
describe = |c|
    match c {
        End => "end"
        Link(_) => "link"
    }

main! = || {
    chain : Chain
    chain = Link(End)
    Stdout.line!(describe(chain))
}
