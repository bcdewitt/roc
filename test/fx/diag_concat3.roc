app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

main! = || {
    # List(I64) concat works as control
    a = [1, 2]
    b = [3, 4]
    c = List.concat(a, b)
    Stdout.line!(c.len().to_str())
}
