app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Does Str.inspect on End overflow even for a trivial nominal type?
Chain := [End, Link(Chain)]

main! = || {
    chain : Chain
    chain = End
    # Test 1: just print without inspect
    Stdout.line!("constructed End ok")
    # Test 2: match (no inspect)
    result = match chain {
        End => "is-end"
        Link(_) => "is-link"
    }
    Stdout.line!(result)
    # Test 3: now try inspect
    Stdout.line!("about to inspect...")
    s = Str.inspect(chain)
    Stdout.line!(s)
}
