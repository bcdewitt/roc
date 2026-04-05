app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant K: Just construct a recursive value, don't recurse on it
Chain := [End, Link(Chain)]

main! = || {
    chain : Chain
    chain = Link(End)
    Stdout.line!(Str.inspect(chain))
}
