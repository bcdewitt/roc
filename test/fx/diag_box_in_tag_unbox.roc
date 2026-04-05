app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Extract Box from tag and unbox
main! = || {
    boxed = Box.box(42)
    tag : [A, B(Box(I64))]
    tag = B(boxed)
    match tag {
        A => Stdout.line!("A")
        B(b) => {
            Stdout.line!("got B, about to unbox")
            val = Box.unbox(b)
            Stdout.line!("B: ${val.to_str()}")
        }
    }
}
