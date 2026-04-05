app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Box(Str) in tag where Str is small (no heap alloc for chars).
# Small strings are <= 23 bytes and stored inline.
main! = || {
    boxed = Box.box("hi")
    tag : [A, B(Box(Str))]
    tag = B(boxed)
    match tag {
        A => Stdout.line!("A")
        B(_) => Stdout.line!("B")
    }
}
