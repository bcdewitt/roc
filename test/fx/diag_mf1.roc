app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Two-field recursive: does field 0 have correct data?
Tree := [Leaf(I64), Node(Tree, Tree)]

main! = || {
    l = Leaf(1)
    r = Leaf(2)
    t = Node(l, r)
    # Access field 0 (left) — expect Leaf discriminant
    left_disc = match t {
        Leaf(_) => "leaf"
        Node(left, _) => match left {
            Leaf(x) => "left-leaf-${x.to_str()}"
            Node(_, _) => "left-node"
        }
    }
    Stdout.line!(left_disc)
}
