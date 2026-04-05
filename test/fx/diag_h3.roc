app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

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
    c1 : Chain
    c1 = End
    Stdout.line!("len(End): ${(length(c1)).to_str()}")
    c2 : Chain
    c2 = Link([End])
    Stdout.line!("len(Link([End])): ${(length(c2)).to_str()}")
    c3 : Chain
    c3 = Link([Link([End])])
    Stdout.line!("len(Link([Link([End])])): ${(length(c3)).to_str()}")
}
