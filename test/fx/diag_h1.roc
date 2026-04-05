app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Minimal: Chain := [End, Link(List(Chain))] — does basic match work?
Chain := [End, Link(List(Chain))]

# Step 1: can we even construct it?
# Step 2: match on outer level
# Step 3: recurse

is_end : Chain -> Str
is_end = |c|
    match c {
        End => "yes"
        Link(_) => "no"
    }

main! = || {
    c1 : Chain
    c1 = End
    c2 : Chain
    c2 = Link([End])
    Stdout.line!("c1 is End: ${is_end(c1)}")
    Stdout.line!("c2 is End: ${is_end(c2)}")
}
