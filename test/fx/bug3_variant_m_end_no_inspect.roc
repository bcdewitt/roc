app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant M: Construct End, just print "done" (no inspect of value)
Chain := [End, Link(Chain)]

main! = || {
    _chain : Chain
    _chain = End
    Stdout.line!("done")
}
