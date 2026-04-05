app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Recursive type without any use — does just creating it crash?
# (ignoring unused variable warning)
SingleRec := [End, Link(SingleRec)]

main! = || {
    inner : SingleRec
    inner = End
    outer : SingleRec
    outer = Link(inner)
    Stdout.line!("before done")
    Stdout.line!("done")
}
