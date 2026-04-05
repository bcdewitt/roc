app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant R: Absolute minimal - just construct and ignore
Chain := [End, Link(Chain)]

main! = || {
    _ = Link(End)
    Stdout.line!("done")
}
