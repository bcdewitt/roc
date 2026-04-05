app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Does the crash require a RECURSIVE nominal type, or is it any Box field in a tag?
# Non-recursive type with Box fields
Container := [Wrap(Box(I64), Box(I64))]

check : Container -> Str
check = |c|
    match c {
        Wrap(a, b) => "${(Box.unbox(a)).to_str()}, ${(Box.unbox(b)).to_str()}"
    }

main! = || {
    r = check(Wrap(Box.box(10), Box.box(20)))
    Stdout.line!(r)
}
