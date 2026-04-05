app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

main! = || {
    a = ["hello"]
    b : List(Str)
    b = []
    c = List.concat(a, b)
    Stdout.line!(c.len().to_str())
}
