app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Does the crash happen when the function accesses ONE field but does NOT recurse?
Tree := [Leaf(I64), Node(Tree, Tree)]

count_one_field : Tree -> I64
count_one_field = |t|
    match t {
        Leaf(x) => x
        Node(left, _) => match left {
            Leaf(x) => x
            Node(_, _) => -1
        }
    }

main! = || {
    t = Node(Leaf(42), Leaf(99))
    c = count_one_field(t)
    Stdout.line!("value: ${c.to_str()}")
}
