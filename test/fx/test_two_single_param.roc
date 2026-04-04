app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Tree := [Leaf(I64), Node(List(Tree))]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(children) =>
            List.fold(children, 1, |acc, c| acc + count(c))
    }

sum_leaves : Tree -> I64
sum_leaves = |t|
    match t {
        Leaf(v) => v
        Node(children) =>
            List.fold(children, 0, |acc, c| acc + sum_leaves(c))
    }

main! = || {
    tree : Tree
    tree = Node([Leaf(1), Leaf(2), Leaf(3)])
    c = count(tree)
    Stdout.line!("count: ${c.to_str()}")
    s = sum_leaves(tree)
    Stdout.line!("sum: ${s.to_str()}")
}
