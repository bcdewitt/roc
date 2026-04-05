app [main!] { pf: platform "./platform/main.roc" }
import pf.Stdout

# Does the crash happen when CALLING a function with a multi-field Node,
# even if the function does NOT recurse?
Tree := [Leaf(I64), Node(Tree, Tree)]

count_nonrecursive : Tree -> I64
count_nonrecursive = |t|
    match t {
        Leaf(_) => 1
        Node(_, _) => 2
    }

main! = || {
    t = Node(Leaf(1), Leaf(2))
    c = count_nonrecursive(t)
    Stdout.line!("count: ${c.to_str()}")
}
