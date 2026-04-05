app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Ch := [End, Link(List(Ch))]

# Does List.rest have the same issue?
with_rest : Ch -> Ch
with_rest = |c|
    match c {
        End => End
        Link(children) =>
            match List.rest(children) {
                Ok(rest_list) =>
                    # don't recurse -- just call a non-recursive function
                    match List.first(rest_list) {
                        Ok(next) => next
                        Err(_) => End
                    }
                Err(_) => End
            }
    }

main! = || {
    c1 : Ch
    c1 = End
    _r = with_rest(c1)
    Stdout.line!("done")
}
