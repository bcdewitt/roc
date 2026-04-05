app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q3: Does the hang happen if we recurse OUTSIDE the match entirely?
# The Ok branch does something else; the recursion is after the match.
Ch := [End, Link(List(Ch))]

f_recurse_outside : Ch -> I64
f_recurse_outside = |c|
    match c {
        End => 0
        Link(children) =>
            # NOTE: we discard the List.first result entirely and recurse on c.
            # At runtime this only works when c = End (see main). Does it COMPILE?
            match List.first(children) {
                Ok(_) => f_recurse_outside(c)
                Err(_) => f_recurse_outside(c)
            }
    }

main! = || {
    _r = f_recurse_outside(End)
    Stdout.line!("Q3: ok")
}
