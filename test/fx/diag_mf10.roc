app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Extract inner chain field from a Link, then just check discriminant of inner
Chain := [End, Link(Chain)]

check_inner_disc : Chain -> I64
check_inner_disc = |c|
    match c {
        End => -1
        Link(inner) => match inner {
            End => 0
            Link(_) => 1
        }
    }

main! = || {
    # Pass Link(End) — inner should be End → disc 0
    r1 = check_inner_disc(Link(End))
    Stdout.line!("Link(End).inner disc: ${r1.to_str()}")
    # Pass Link(Link(End)) — inner should be Link → disc 1
    r2 = check_inner_disc(Link(Link(End)))
    Stdout.line!("Link(Link(End)).inner disc: ${r2.to_str()}")
}
