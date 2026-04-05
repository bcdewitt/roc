app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Tag with NON-Box payload — confirm tags work at all  
main! = || {
    tag : [A, B(I64)]
    tag = B(42)
    match tag {
        A => Stdout.line!("A")
        B(x) => Stdout.line!("B: ${x.to_str()}")
    }
}
