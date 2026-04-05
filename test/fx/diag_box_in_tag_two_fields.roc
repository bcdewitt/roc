app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Tag with Box + second field — offset issue?
main! = || {
    boxed = Box.box(42)
    tag : [A, B(I64, Box(I64))]
    tag = B(99, boxed)
    match tag {
        A => Stdout.line!("A")
        B(x, b) => {
            Stdout.line!("x: ${x.to_str()}")
            val = Box.unbox(b)
            Stdout.line!("b: ${val.to_str()}")
        }
    }
}
