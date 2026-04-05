app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# Recursion using List.first specifically
first_length : Chain -> I64
first_length = |c|
    match c {
        End => 0
        Link(rest) =>
            match List.first(rest) {
                Ok(next) => 1 + first_length(next)
                Err(_) => 0
            }
    }

main! = || {
    Stdout.line!("before")
    c : Chain
    c = End
    n = first_length(c)
    Stdout.line!("result: ${n.to_str()}")
}
