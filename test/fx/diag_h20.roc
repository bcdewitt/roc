app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Ch := [End, Link(List(Ch))]

# Does recursive call work if we use drop_first instead of List.first?
pass_drop_first : Ch -> Ch
pass_drop_first = |c|
    match c {
        End => End
        Link(children) =>
            match List.first(List.drop_first(children, 1)) {
                Ok(next) => pass_drop_first(next)
                Err(_) => End
            }
    }

main! = || {
    c1 : Ch
    c1 = End
    _r = pass_drop_first(c1)
    Stdout.line!("done")
}
