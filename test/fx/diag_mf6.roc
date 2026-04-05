app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Baseline: single-field Box to function — does it work?
Chain := [End, Link(Chain)]

check_chain : Chain -> Str
check_chain = |c|
    match c {
        End => "end"
        Link(inner) => match inner {
            End => "link-end"
            Link(_) => "link-link"
        }
    }

main! = || {
    # Link(End) → should show "link-end"
    r = check_chain(Link(End))
    Stdout.line!("chain: ${r}")
}
