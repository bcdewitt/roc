app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q8: Does extracting from Result FIRST, then recursing in a nested call, change anything?
# i.e., the Ok branch calls a helper that recurses, not the function itself
Ch := [End, Link(List(Ch))]

helper : Ch -> Ch
helper = |c| go(c)

go : Ch -> Ch
go = |c|
    match c {
        End => End
        Link(children) =>
            match List.first(children) {
                Ok(next) => helper(next)   # call helper which calls go -- mutual recursion via helper
                Err(_) => End
            }
    }

main! = || {
    _r = go(End)
    Stdout.line!("Q8: ok")
}
