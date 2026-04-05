app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Simplest possible: pass a SINGLE-FIELD Box tag to a function and unbox it
Container := [Wrap(Box(I64))]

check : Container -> I64
check = |c|
    match c {
        Wrap(a) => Box.unbox(a)
    }

main! = || {
    r = check(Wrap(Box.box(42)))
    Stdout.line!("val: ${r.to_str()}")
}
