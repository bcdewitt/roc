app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant I: Non-recursive List(Str) — allocation only, no recursion
# Tests whether List(Str) is broken at a basic level

main! = || {
    strs = ["hello", "world"]
    Stdout.line!(Str.join_with(strs, " "))
}
