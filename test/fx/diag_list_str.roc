app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Does List(Str) return from a NON-recursive function work?
get_strs_nonrecursive : I64 -> List(Str)
get_strs_nonrecursive = |_n|
    ["hello", "world"]

main! = || {
    result = get_strs_nonrecursive(0)
    Stdout.line!(Str.join_with(result, " "))
}
