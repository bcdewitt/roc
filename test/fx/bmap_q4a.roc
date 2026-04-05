app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q4a: Return type Ch->I64 instead of Ch->Ch
Ch := [End, Link(List(Ch))]

f_i64 : Ch -> I64
f_i64 = |c|
    match c {
        End => 0
        Link(children) =>
            match List.first(children) {
                Ok(next) => 1 + f_i64(next)
                Err(_) => 0
            }
    }

main! = || {
    _r = f_i64(End)
    Stdout.line!("Q4a: ok")
}
