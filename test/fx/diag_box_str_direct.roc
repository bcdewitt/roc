app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Box(Str) but used directly, no tag wrapping
main! = || {
    boxed = Box.box("hello")
    val = Box.unbox(boxed)
    Stdout.line!("val: ${val}")
}
