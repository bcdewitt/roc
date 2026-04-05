app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant E: three recursive payloads
# Tests whether 2 is the boundary or any >1 recursive payload fails
Tree := [Leaf(I64), Node(Tree, Tree, Tree)]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(a, b, c) => 1 + count(a) + count(b) + count(c)
    }

main! = || {
    tree : Tree
    tree = Node(Leaf(1), Leaf(2), Leaf(3))
    c = count(tree)
    Stdout.line!("count: ${c.to_str()}")
}
