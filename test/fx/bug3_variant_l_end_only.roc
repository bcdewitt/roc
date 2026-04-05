app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant L: Just construct End (no Link), inspect it
Chain := [End, Link(Chain)]

main! = || {
    chain : Chain
    chain = End
    Stdout.line!(Str.inspect(chain))
}
