app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant N: Construct End, match on it (no inspect)
Chain := [End, Link(Chain)]

describe : Chain -> Str
describe = |c|
    match c {
        End => "end"
        Link(_) => "link"
    }

main! = || {
    chain : Chain
    chain = End
    Stdout.line!(describe(chain))
}
