app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Two-level recursion — does crash need depth > 1?
get_strs : I64 -> List(Str)
get_strs = |n|
    if n <= 0
        []
    else
        List.concat(get_strs(n - 1), [n.to_str()])

main! = || {
    result = get_strs(1)
    Stdout.line!(Str.join_with(result, " "))
}
