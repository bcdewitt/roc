app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant H: Nominal type with I64 payload, returning List(Str)
# Tests: nominal + List(Str) return + I64 payload (not Str payload)
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
    tree = Leaf(42)
    result = collect_strs(tree)
    Stdout.line!(Str.join_with(result, " "))
}
