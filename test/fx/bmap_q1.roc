app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q1: Hang requires List INSIDE nominal type?
# A := [End, Node(A)] -- no List baked in -- but we pass List(A) to List.first
A := [End, Node(A)]

f_external_list : A, List(A) -> A
f_external_list = |_a, lst|
    match List.first(lst) {
        Ok(next) => f_external_list(next, lst)
        Err(_) => End
    }

main! = || {
    _r = f_external_list(End, [])
    Stdout.line!("Q1: ok")
}
