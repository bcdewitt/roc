app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Bug 2 variant D: Str return (not List(Str)), with nominal type containing Str
# Tests whether single Str return works or if List(Str) is required for crash
Tree := [Leaf(Str), Branch(List(Tree))]

first_label : Tree -> Str
first_label = |t|
    match t {
        Leaf(s) => s
        Branch(children) =>
            match List.first(children) {
                Ok(child) => first_label(child)
                Err(_) => "empty"
            }
    }

main! = || {
    tree : Tree
    tree = Branch([Leaf("hello"), Leaf("world")])
    result = first_label(tree)
    Stdout.line!(result)
}
