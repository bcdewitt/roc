app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

main! = || {
    a : List(Str)
    a = ["hello"]
    Stdout.line!("created a")
    b : List(Str)
    b = ["world"]
    Stdout.line!("created b")
    c = List.concat(a, b)
    Stdout.line!("concat done")
    Stdout.line!(Str.join_with(c, " "))
}
