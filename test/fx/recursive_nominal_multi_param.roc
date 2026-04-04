app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 1: Multi-parameter recursive function on nominal type segfaults at runtime.
# Single-parameter recursion works; two or more parameters causes SIGSEGV.

Tree := [Leaf(I64), Node(List(Tree))]

# Single-parameter recursion: works
count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(children) =>
            List.fold(children, 1, |acc, c| acc + count(c))
    }

# Multi-parameter recursion: segfaults
count_if : Tree, I64 -> I64
count_if = |t, target|
    match t {
        Leaf(v) => if v == target 1 else 0
        Node(children) =>
            List.fold(children, 0, |acc, c| acc + count_if(c, target))
    }

main! = || {
    tree : Tree
    tree = Node([Leaf(1), Leaf(2), Leaf(1)])

    single = count(tree)
    Stdout.line!("count: ${single.to_str()}")

    multi = count_if(tree, 1)
    Stdout.line!("count_if: ${multi.to_str()}")
}
