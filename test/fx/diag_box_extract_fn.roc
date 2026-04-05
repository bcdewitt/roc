app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Diagnostic: Extract Box from tag, pass to function that unboxes
unbox_it : Box(I64) -> I64
unbox_it = |b| Box.unbox(b)

main! = || {
    boxed = Box.box(42)
    Stdout.line!("direct unbox: ${Box.unbox(boxed).to_str()}")
    
    tag : [A, B(Box(I64))]
    tag = B(boxed)
    match tag {
        A => Stdout.line!("A")
        B(b) => {
            val = unbox_it(b)
            Stdout.line!("via tag: ${val.to_str()}")
        }
    }
}
