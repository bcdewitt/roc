app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Is it Str.inspect specifically, or any function that gets Chain as param?
Chain := [End, Link(Chain)]

# User-defined inspect analog
to_str : Chain -> Str
to_str = |c|
    match c {
        End => "End"
        Link(inner) => "Link(${to_str(inner)})"
    }

main! = || {
    chain : Chain
    chain = End
    Stdout.line!("about to call to_str")
    s = to_str(chain)
    Stdout.line!(s)
}
