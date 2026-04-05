app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Does this overflow when Ch := [End, Link(List(Ch))]?
Ch := [End, Link(List(Ch))]

get_disc : Ch -> I64
get_disc = |c|
    match c {
        End => 0
        Link(_) => 1
    }

# Now test: get the discriminant of something obtained via List.first
first_disc : Ch -> I64
first_disc = |c|
    match c {
        End => -1
        Link(children) =>
            match List.first(children) {
                Ok(next) => get_disc(next)
                Err(_) => -2
            }
    }

main! = || {
    c1 : Ch
    c1 = End
    Stdout.line!("get_disc(End): ${(get_disc(c1)).to_str()}")
    c2 : Ch
    c2 = Link([End])
    Stdout.line!("first_disc(Link([End])): ${(first_disc(c2)).to_str()}")
}
