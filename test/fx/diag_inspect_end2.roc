app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(Chain)]

main! = || {
    Stdout.line!("start")
    chain : Chain
    chain = End
    Stdout.line!(Str.inspect(chain))
}
