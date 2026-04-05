app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Does List(Str) return from a recursive function work (simpler recursion)?
get_strs : I64 -> List(Str)
get_strs = |n|
    if n <= 0
        []
    else
        ["x"]

main! = || {
    result = get_strs(1)
    Stdout.line!(Str.join_with(result, " "))
}
