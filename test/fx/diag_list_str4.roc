app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Is List.concat(List(Str), List(Str)) the trigger, or the recursive call?
get_strs : I64 -> List(Str)
get_strs = |n|
    if n <= 0
        []
    else {
        inner = get_strs(n - 1)
        inner
    }

main! = || {
    result = get_strs(2)
    Stdout.line!(Str.join_with(result, " "))
}
