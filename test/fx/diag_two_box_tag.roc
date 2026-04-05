app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Two Box fields in a tag, no recursion — does incref work?
Pair := [Pair(Box(I64), Box(I64))]

main! = || {
    a = Box.box(1.I64)
    b = Box.box(2.I64)
    p = Pair(a, b)
    x = match p {
        Pair(a2, b2) => Box.unbox(a2) + Box.unbox(b2)
    }
    Stdout.line!("sum: ${x.to_str()}")
}
