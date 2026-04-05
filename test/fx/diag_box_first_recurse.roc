app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Minimal: recursive FIRST field with a simple recursive call (like f)
Tree := [Leaf(I64), Node(Tree, I64)]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(child, _) => 1 + count(child)
    }

main! = || {
    leaf : Tree
    leaf = Leaf(1)
    tree : Tree
    tree = Node(leaf, 99)
    v = count(tree)
    Stdout.line!("count: ${v.to_str()}")
}
