app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# List.concat of two List(Str) in a NON-recursive context
main! = || {
    a = ["hello"]
    b = ["world"]
    c = List.concat(a, b)
    Stdout.line!(Str.join_with(c, " "))
}
