app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant F: one recursive + one non-recursive payload
# Tests whether the issue is specifically TWO recursive payloads,
# or any second payload alongside a recursive one
Tree := [Leaf(I64), Node(Tree, I64)]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(child, _val) => 1 + count(child)
    }

main! = || {
    tree : Tree
    tree = Node(Leaf(1), 99)
    c = count(tree)
    Stdout.line!("count: ${c.to_str()}")
}
