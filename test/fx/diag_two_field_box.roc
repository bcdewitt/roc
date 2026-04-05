app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Test: two fields where each needs implicit boxing via a recursive nominal type
Tree := [Leaf(I64), Node(Tree, Tree)]

# Just construct - don't recurse yet
main! = || {
    l : Tree
    l = Leaf(1)
    r : Tree
    r = Leaf(2)
    t : Tree
    t = Node(l, r)
    # Just inspect discriminant — don't recurse
    out = match t {
        Leaf(x) => x.to_str()
        Node(_, _) => "node"
    }
    Stdout.line!(out)
}
