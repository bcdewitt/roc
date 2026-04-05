app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Does it matter if args to Node are named vs inline?
Tree := [Leaf(I64), Node(Tree, Tree)]

check : Tree -> Str
check = |t|
    match t {
        Leaf(x) => x.to_str()
        Node(left, _) => match left {
            Leaf(x) => "left-leaf-${x.to_str()}"
            Node(_, _) => "left-node"
        }
    }

main! = || {
    # Variant A: inline args
    a = check(Node(Leaf(1), Leaf(2)))
    Stdout.line!("inline: ${a}")
    # Variant B: named args
    l = Leaf(1)
    r = Leaf(2)
    b = check(Node(l, r))
    Stdout.line!("named: ${b}")
}
