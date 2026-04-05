app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant E: Leaf-only tree (no Branch), List(Str) return
# Tests whether recursion into children is needed, or just the type definition triggers it
Tree := [Leaf(Str), Branch(List(Tree))]

collect_labels : Tree -> List(Str)
collect_labels = |t|
    match t {
        Leaf(s) => [s]
        Branch(children) =>
            List.fold(children, [], |acc, c| List.concat(acc, collect_labels(c)))
    }

main! = || {
    tree : Tree
    tree = Leaf("hello")
    labels = collect_labels(tree)
    Stdout.line!(Str.join_with(labels, " "))
}
