app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# Recursive through inner match on List.first result
inner_recurse : Chain -> I64
inner_recurse = |c|
    match c {
        End => 0
        Link(rest) =>
            match List.first(rest) {
                Ok(next) => 1 + inner_recurse(next)
                Err(_) => 0
            }
    }

main! = || {
    Stdout.line!("before")
    c : Chain
    c = End
    n = inner_recurse(c)
    Stdout.line!("result: ${n.to_str()}")
}
