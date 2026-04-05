app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 3 variant A: single recursive payload — expected to WORK (control)
Tree := [Leaf(I64), Node(List(Tree))]

count : Tree -> I64
count = |t|
    match t {
        Leaf(_) => 1
        Node(children) =>
            List.fold(children, 1, |acc, c| acc + count(c))
    }

main! = || {
    tree : Tree
    tree = Node([Leaf(1), Leaf(2)])
    c = count(tree)
    Stdout.line!("count: ${c.to_str()}")
}
