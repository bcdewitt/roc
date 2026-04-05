app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Recursive type with non-refcounted payload only (I64, no Str)
# If RC is the problem, this should work since I64 doesn't need RC
NumChain := [End, Link(I64, NumChain)]

main! = || {
    chain = Link(1, Link(2, Link(3, End)))
    match chain {
        End => Stdout.line!("empty")
        Link(x, _) => Stdout.line!("first: ${x.to_str()}")
    }
}
