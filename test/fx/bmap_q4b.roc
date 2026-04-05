app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q4b: Return type Ch->Str -- does it hang?
Ch := [End, Link(List(Ch))]

f_str : Ch -> Str
f_str = |c|
    match c {
        End => "end"
        Link(children) =>
            match List.first(children) {
                Ok(next) => f_str(next)
                Err(_) => "empty"
            }
    }

main! = || {
    _r = f_str(End)
    Stdout.line!("Q4b: ok")
}
