app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant F: List(U8) return (heap-allocated like Str, but not Str)
# Tests whether any heap-allocated element type triggers it, or specifically Str
Tree := [Leaf(Str), Branch(List(Tree))]

collect_first_bytes : Tree -> List(U8)
collect_first_bytes = |t|
    match t {
        Leaf(s) => {
            bytes = Str.to_utf8(s)
            match List.first(bytes) {
                Ok(b) => [b]
                Err(_) => []
            }
        }
        Branch(children) =>
            List.fold(children, [], |acc, c| List.concat(acc, collect_first_bytes(c)))
    }

main! = || {
    tree : Tree
    tree = Branch([Leaf("hello"), Leaf("world")])
    result = collect_first_bytes(tree)
    Stdout.line!(Str.inspect(result))
}
