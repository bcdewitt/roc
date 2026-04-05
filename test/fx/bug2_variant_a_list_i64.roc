app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant A: List(I64) return — expected to WORK (control)
Tree := [Leaf(I64), Branch(List(Tree))]

collect_values : Tree -> List(I64)
collect_values = |t|
    match t {
        Leaf(n) => [n]
        Branch(children) =>
            List.fold(children, [], |acc, c| List.concat(acc, collect_values(c)))
    }

main! = || {
    tree : Tree
    tree = Branch([Leaf(1), Leaf(2)])
    result = collect_values(tree)
    Stdout.line!(Str.inspect(result))
}
