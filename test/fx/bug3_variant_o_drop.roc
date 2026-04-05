app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant O: Pass value to function that drops it
# Tests if refcount drop triggers the crash
Chain := [End, Link(Chain)]

consume : Chain -> Str
consume = |_c|
    "consumed"

main! = || {
    chain : Chain
    chain = End
    result = consume(chain)
    Stdout.line!(result)
}
