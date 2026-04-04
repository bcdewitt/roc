app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Non-recursive function with 2 params plus captured param in lambda
Tree := [Leaf(I64), Node(List(Tree))]

# Multi-param, no recursion, captures param in lambda
count_matching : Tree, I64 -> I64
count_matching = |t, target|
    match t {
        Leaf(v) => if v == target 1 else 0
        Node(children) =>
            List.fold(children, 0, |acc, c|
                match c {
                    Leaf(v) => acc + (if v == target 1 else 0)
                    Node(_) => acc
                }
            )
    }

main! = || {
    tree : Tree
    tree = Node([Leaf(1), Leaf(2), Leaf(1)])
    result = count_matching(tree, 1)
    Stdout.line!("result: ${result.to_str()}")
}
