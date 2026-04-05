app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Minimal: I64 as FIRST field, recursive as second (same as variant a)
# [Leaf(I64), Node(I64, Tree)] — if i64 is field 0, does it pass?
Tree := [Leaf(I64), Node(I64, Tree)]

main! = || {
    leaf : Tree
    leaf = Leaf(1)
    tree : Tree
    tree = Node(99, leaf)
    match tree {
        Leaf(_) => Stdout.line!("leaf")
        Node(_, _) => Stdout.line!("node")
    }
}
