app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2: Recursive function on nominal type returning List(Str) crashes.
# Returning List(I64) works fine; returning List(Str) crashes.

Tree := [Leaf(Str), Branch(List(Tree))]

# Returns List(Str): crashes
collect_labels : Tree -> List(Str)
collect_labels = |t|
    match t {
        Leaf(s) => [s]
        Branch(children) =>
            List.fold(children, [], |acc, c| List.concat(acc, collect_labels(c)))
    }

main! = || {
    tree : Tree
    tree = Branch([Leaf("hello"), Leaf("world")])

    labels = collect_labels(tree)
    Stdout.line!(Str.join_with(labels, " "))
}
