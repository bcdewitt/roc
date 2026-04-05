app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Test with a single-field recursive type (known working) — as baseline
Chain := [End, Link(Chain)]

main! = || {
    inner : Chain
    inner = End
    outer : Chain
    outer = Link(inner)
    # Extract and match the inner field
    out = match outer {
        End => "end"
        Link(c) => match c {
            End => "link-end"
            Link(_) => "link-link"
        }
    }
    Stdout.line!(out)
}
