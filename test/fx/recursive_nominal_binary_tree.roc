app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3: Nominal type with multiple recursive payloads in a single tag variant
# (binary tree pattern) segfaults. Must route through List(Tree) as workaround.

Tree := [Leaf(I64), Node(Tree, Tree)]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(l, r) => 1 + count(l) + count(r)
    }

main! = || {
    tree : Tree
    tree = Node(Leaf(1), Leaf(2))

    c = count(tree)
    Stdout.line!("count: ${c.to_str()}")
}
