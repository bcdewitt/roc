app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant D: two non-recursive payloads in one tag
# Tests whether multiple payloads per tag is the issue, or specifically recursive payloads
Tree := [Leaf(I64), Node(I64, I64)]

sum : Tree -> I64
sum = |t|
    match t {
        Leaf(n) => n
        Node(a, b) => a + b
    }

main! = || {
    tree : Tree
    tree = Node(1, 2)
    s = sum(tree)
    Stdout.line!("sum: ${s.to_str()}")
}
