app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Ch := [End, Link(List(Ch))]

# Test: List.get instead of List.first
pass_get : Ch -> Ch
pass_get = |c|
    match c {
        End => End
        Link(children) =>
            match List.get(children, 0) {
                Ok(next) => pass_get(next)
                Err(_) => End
            }
    }

main! = || {
    c1 : Ch
    c1 = End
    _r = pass_get(c1)
    Stdout.line!("done")
}
