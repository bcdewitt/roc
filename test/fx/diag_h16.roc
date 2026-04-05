app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

inner_recurse : Chain -> I64
inner_recurse = |c|
    match c {
        End => 0.I64
        Link(rest) =>
            match List.first(rest) {
                Ok(next) => 1.I64 + inner_recurse(next)
                Err(_) => 0.I64
            }
    }

main! = || {
    Stdout.line!("before")
    c : Chain
    c = End
    _ignored = inner_recurse(c)
    Stdout.line!("after")
}
