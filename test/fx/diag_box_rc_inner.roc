app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Box with refcounted inner (Str), non-recursive
main! = || {
    boxed = Box.box("hello")
    tag : [A, B(Box(Str))]
    tag = B(boxed)
    match tag {
        A => Stdout.line!("A")
        B(_) => Stdout.line!("B (no unbox)")
    }
}
