app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Test: Str.inspect on a NON-recursive nominal type
NonRec := [Leaf(I64), Branch(Str)]

main! = || {
    x1 : NonRec
    x1 = Leaf(42)
    x2 : NonRec
    x2 = Branch("hello")
    Stdout.line!(Str.inspect(x1))
    Stdout.line!(Str.inspect(x2))
}
