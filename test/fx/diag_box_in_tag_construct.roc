app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Does Box inside tag crash during construction only?
main! = || {
    boxed = Box.box(42)
    tag : [A, B(Box(I64))]
    tag = B(boxed)
    match tag {
        A => Stdout.line!("A")
        B(_) => Stdout.line!("B (not unboxing)")
    }
}
