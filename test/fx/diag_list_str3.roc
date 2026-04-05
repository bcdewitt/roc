app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Does List(Str) return from a function that actually recurses work?
get_strs : I64 -> List(Str)
get_strs = |n|
    if n <= 0
        []
    else
        List.concat(get_strs(n - 1), [n.to_str()])

main! = || {
    result = get_strs(2)
    Stdout.line!(Str.join_with(result, " "))
}
