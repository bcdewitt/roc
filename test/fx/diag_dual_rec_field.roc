app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Two fields but ONLY the recursive one (dummy + recursive)
DualRec := [End, Link(I64, DualRec)]

main! = || {
    inner : DualRec
    inner = End
    outer : DualRec
    outer = Link(0, inner)
    match outer {
        End => Stdout.line!("end")
        Link(_, _) => Stdout.line!("link")
    }
}
