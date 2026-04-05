app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Try List(I64) recursive return - does crash require Str type specifically?
get_nums : I64 -> List(I64)
get_nums = |n|
    if n <= 0
        []
    else
        List.concat(get_nums(n - 1), [n])

main! = || {
    result = get_nums(3)
    Stdout.line!(result.len().to_str())
}
