app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant Q: Construct Link(End) without using Inspect
Chain := [End, Link(Chain)]

main! = || {
    Stdout.line!("before End")
    e : Chain
    e = End
    Stdout.line!("after End, before Link")
    chain : Chain
    chain = Link(e)
    Stdout.line!("after Link")
}
