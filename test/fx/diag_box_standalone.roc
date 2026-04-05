app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Box standalone (no tag) — confirm Box.box/unbox baseline
main! = || {
    b = Box.box(42)
    val = Box.unbox(b)
    Stdout.line!("val: ${val.to_str()}")
}
