app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Single-field recursive: when passed to function, does reading the discriminant work?
Chain := [End, Link(Chain)]

get_disc : Chain -> I64
get_disc = |c|
    match c {
        End => 0
        Link(_) => 1
    }

main! = || {
    e = End
    l = Link(End)
    d1 = get_disc(e)
    d2 = get_disc(l)
    Stdout.line!("End disc: ${d1.to_str()}")
    Stdout.line!("Link disc: ${d2.to_str()}")
}
