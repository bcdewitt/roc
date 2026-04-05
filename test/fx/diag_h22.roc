app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Ch := [End, Link(List(Ch))]

# Test: use List.is_empty to avoid matching on Result, then use List.first
pass_is_empty : Ch -> Ch
pass_is_empty = |c|
    match c {
        End => End
        Link(children) =>
            if List.is_empty(children) then
                End
            else
                match List.first(children) {
                    Ok(next) => pass_is_empty(next)
                    Err(_) => End
                }
    }

main! = || {
    c1 : Ch
    c1 = End
    _r = pass_is_empty(c1)
    Stdout.line!("done")
}
