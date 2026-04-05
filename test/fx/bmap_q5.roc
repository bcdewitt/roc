app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q5: Is `Ok` special vs any two-tag union?
# Simulate Maybe with a plain tag union embedded in Ch, use List.get -> Result, map to our own tags
Ch := [End, Link(List(Ch))]

# Helper: returns 1 if Ok, 0 if Err -- forcing use of ok_or idiom to unwrap Ch
f_okval : Ch -> Ch
f_okval = |c|
    match c {
        End => End
        Link(children) =>
            f_okval(List.first(children).ok_or(End))
    }

main! = || {
    _r = f_okval(End)
    Stdout.line!("Q5: ok")
}
