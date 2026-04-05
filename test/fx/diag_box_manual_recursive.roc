app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Manual Box wrapping of a tag union — does this work?
MyTag := [A, B(Box(MyTag))]

main! = || {
    inner : MyTag
    inner = A
    boxed = Box.box(inner)
    outer : MyTag
    outer = B(boxed)
    Stdout.line!("constructed")
}
