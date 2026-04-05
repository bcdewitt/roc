app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant G: I64 -> List(I64) recursive, no nominal type
# Control for variant C — same pattern but with I64 instead of Str

get_nums : I64 -> List(I64)
get_nums = |n|
    if n <= 0
        []
    else
        List.concat(get_nums(n - 1), [n])

main! = || {
    result = get_nums(3)
    Stdout.line!(Str.inspect(result))
}
