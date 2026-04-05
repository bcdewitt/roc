app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Ch := [End, Link(List(Ch))]

# Recursive, but returns the value directly (no arithmetic)
pass_through : Ch -> Ch
pass_through = |c|
    match c {
        End => End
        Link(rest) =>
            match List.first(rest) {
                Ok(next) => pass_through(next)
                Err(_) => End
            }
    }

main! = || {
    c1 : Ch
    c1 = End
    result = pass_through(c1)
    label =
        match result {
            End => "End"
            Link(_) => "Link"
        }
    Stdout.line!("done: ${label}")
}
