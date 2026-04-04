app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Tree := [Leaf(I64), Node(List(Tree))]

# Single-param defined FIRST
count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(children) =>
            List.fold(children, 1, |acc, c| acc + count(c))
    }

# Multi-param defined SECOND
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
    # But call multi-param FIRST
    result = count_if(tree, 1)
    Stdout.line!("count_if: ${result.to_str()}")
    c = count(tree)
    Stdout.line!("count: ${c.to_str()}")
}
