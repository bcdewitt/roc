app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

main! = || {
    Stdout.line!("before list.first")
    mylist : List(Chain)
    mylist = [End]
    result = List.first(mylist)
    Stdout.line!("after list.first")
    match result {
        Ok(_) => Stdout.line!("got one")
        Err(_) => Stdout.line!("empty")
    }
}
