app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Single recursive field only (same as Chain but with explicit type)
# Tests if single-field box path crashes
SingleRec := [End, Link(SingleRec)]

main! = || {
    inner : SingleRec
    inner = End
    outer : SingleRec
    outer = Link(inner)
    match outer {
        End => Stdout.line!("end")
        Link(_) => Stdout.line!("link")
    }
}
