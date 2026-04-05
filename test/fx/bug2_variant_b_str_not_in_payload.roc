app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant B: List(Str) return, Str NOT in the nominal type's payload
# Tests whether the crash requires Str to appear in BOTH places
NumTree := [Leaf(I64), Branch(List(NumTree))]

collect_strs : NumTree -> List(Str)
collect_strs = |t|
    match t {
        Leaf(n) => [n.to_str()]
        Branch(children) =>
            List.fold(children, [], |acc, c| List.concat(acc, collect_strs(c)))
    }

main! = || {
    tree : NumTree
    tree = Branch([Leaf(1), Leaf(2)])
    result = collect_strs(tree)
    Stdout.line!(Str.join_with(result, " "))
}
