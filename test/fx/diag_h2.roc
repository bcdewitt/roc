app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# Test List.first on a list of Chain
test_first : Chain -> Str
test_first = |c|
    match c {
        End => "end"
        Link(rest) =>
            match List.first(rest) {
                Ok(next) => "got-next"
                Err(_) => "empty-list"
            }
    }

main! = || {
    c1 : Chain
    c1 = End
    c2 : Chain
    c2 = Link([End])
    c3 : Chain
    c3 = Link([])
    Stdout.line!(test_first(c1))
    Stdout.line!(test_first(c2))
    Stdout.line!(test_first(c3))
}
