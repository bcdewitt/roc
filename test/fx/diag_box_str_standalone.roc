app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Box(Str) standalone, decref only (no tag). Confirms standalone Box(Str) RC works.
main! = || {
    boxed = Box.box("hello")
    val = Box.unbox(boxed)
    Stdout.line!(val)
}
