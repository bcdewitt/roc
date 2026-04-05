app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant C: two recursive payloads, leaf-only (no runtime recursion)
# Tests whether the TYPE definition alone triggers the bug, or runtime recursion is needed
Tree := [Leaf(I64), Node(Tree, Tree)]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(l, r) => 1 + count(l) + count(r)
    }

main! = || {
    tree : Tree
    tree = Leaf(42)
    c = count(tree)
    Stdout.line!("count: ${c.to_str()}")
}
