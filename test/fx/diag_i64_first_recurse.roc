app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Same but I64 is FIRST field (same structure as variant a which passes)
Tree := [Leaf(I64), Node(I64, Tree)]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(_, child) => 1 + count(child)
    }

main! = || {
    leaf : Tree
    leaf = Leaf(1)
    tree : Tree
    tree = Node(99, leaf)
    v = count(tree)
    Stdout.line!("count: ${v.to_str()}")
}
