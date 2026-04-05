app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Does the dev backend handle Box types at all?
main! = || {
    x = Box.box(42)
    y = Box.unbox(x)
    Stdout.line!("unboxed: ${y.to_str()}")
}
