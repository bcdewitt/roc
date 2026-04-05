app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Minimal: recursive as FIRST field, I64 as second
# [Leaf(I64), Node(Tree, I64)] — if box is field 0, does incref get tag discriminant?
Tree := [Leaf(I64), Node(Tree, I64)]

main! = || {
    leaf : Tree
    leaf = Leaf(1)
    tree : Tree
    tree = Node(leaf, 99)
    match tree {
        Leaf(_) => Stdout.line!("leaf")
        Node(_, _) => Stdout.line!("node")
    }
}
