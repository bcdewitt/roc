app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Str directly in tag union (no Box). Isolates Box vs general RC-in-tag.
main! = || {
    tag : [A, B(Str)]
    tag = B("hello")
    match tag {
        A => Stdout.line!("A")
        B(_) => Stdout.line!("B")
    }
}
