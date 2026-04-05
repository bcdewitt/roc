app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q7: Mutual recursion -- does that also hang?
Ch := [End, Link(List(Ch))]

f_go : Ch -> Ch
f_go = |c| f_step(c)

f_step : Ch -> Ch
f_step = |c|
    match c {
        End => End
        Link(children) =>
            match List.first(children) {
                Ok(next) => f_go(next)
                Err(_) => End
            }
    }

main! = || {
    _r = f_go(End)
    Stdout.line!("Q7: ok")
}
