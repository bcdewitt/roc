app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

main! = || {
    # Empty list concat - no elements to incref
    a : List(Str)
    a = []
    b : List(Str)
    b = ["hello"]
    c = List.concat(a, b)
    Stdout.line!(c.len().to_str())
}
