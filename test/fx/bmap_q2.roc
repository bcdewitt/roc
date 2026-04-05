app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q2: Does Ok(next) need to be USED in the recursive call?
# We extract next but recurse on the ORIGINAL argument, not next.
Ch := [End, Link(List(Ch))]

f_ignore_next : Ch -> Ch
f_ignore_next = |c|
    match c {
        End => End
        Link(children) =>
            match List.first(children) {
                Ok(_ignored) => f_ignore_next(c)  # recurse on c, not on the Ok payload
                Err(_) => End
            }
    }

main! = || {
    _r = f_ignore_next(End)
    Stdout.line!("Q2: ok")
}
