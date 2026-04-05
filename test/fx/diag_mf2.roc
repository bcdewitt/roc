app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Two-field recursive: does field 1 have correct data?
Tree := [Leaf(I64), Node(Tree, Tree)]

main! = || {
    l = Leaf(1)
    r = Leaf(2)
    t = Node(l, r)
    right_disc = match t {
        Leaf(_) => "leaf"
        Node(_, right) => match right {
            Leaf(x) => "right-leaf-${x.to_str()}"
            Node(_, _) => "right-node"
        }
    }
    Stdout.line!(right_disc)
}
