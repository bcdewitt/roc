app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# NON-recursive, uses List.first, returns I64
first_step : Chain -> I64
first_step = |c|
    match c {
        End => 0
        Link(rest) =>
            match List.first(rest) {
                Ok(_next) => 1
                Err(_) => 0
            }
    }

main! = || {
    Stdout.line!("before")
    c : Chain
    c = End
    n = first_step(c)
    Stdout.line!("result: ${n.to_str()}")
}
