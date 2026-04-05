app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# Define but don't call length
length : Chain -> I64
length = |c|
    match c {
        End => 0
        Link(rest) =>
            match List.first(rest) {
                Ok(next) => 1 + length(next)
                Err(_) => 0
            }
    }

main! = || {
    Stdout.line!("hello")
}
