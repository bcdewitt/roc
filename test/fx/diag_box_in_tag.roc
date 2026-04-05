app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Non-recursive tag with Box payload
main! = || {
    boxed = Box.box(42)
    tag : [A, B(Box(I64))]
    tag = B(boxed)
    match tag {
        A => Stdout.line!("A")
        B(b) => Stdout.line!("B: ${Box.unbox(b).to_str()}")
    }
}
