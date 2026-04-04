app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Recursive function with 2 params, recursive call captures param
Tree := [Leaf(I64), Node(List(Tree))]

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
    result = count_if(tree, 1)
    Stdout.line!("result: ${result.to_str()}")
}
