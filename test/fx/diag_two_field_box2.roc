app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Test: extract ONE field from Node, check its discriminant (don't box/incref it)
Tree := [Leaf(I64), Node(Tree, Tree)]

main! = || {
    l : Tree
    l = Leaf(1)
    r : Tree
    r = Leaf(2)
    t : Tree
    t = Node(l, r)
    out = match t {
        Leaf(x) => x.to_str()
        Node(left, _) => match left {
            Leaf(x) => x.to_str()
            Node(_, _) => "nested node"
        }
    }
    Stdout.line!(out)
}
