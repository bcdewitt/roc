app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Tests for: collect_vars, contains_var

Expr := [
    IntLit(I64),
    Var(Str),
    BinOp(Str, List(Expr)),
    Call(Str, List(Expr)),
    Cond(List(Expr)),
    LetIn(Str, List(Expr)),
    FnDef(Str, List(Str), List(Expr)),
]

int = |n| IntLit(n)
ref = |name| Var(name)
add = |l, r| BinOp("+", [l, r])
let_in = |name, val, body| LetIn(name, [val, body])

left_of = |list| list.first().ok_or(IntLit(0))
right_of = |list| list.get(1).ok_or(IntLit(0))
third_of = |list| list.get(2).ok_or(IntLit(0))

collect_vars : Expr -> List(Str)
collect_vars = |expr|
    match expr {
        IntLit(_) => []
        Var(name) => [name]
        BinOp(_, ch) => collect_vars(left_of(ch)).concat(collect_vars(right_of(ch)))
        Call(_, args) => args.fold([], |acc, a| acc.concat(collect_vars(a)))
        Cond(p) => collect_vars(left_of(p)).concat(collect_vars(right_of(p))).concat(collect_vars(third_of(p)))
        LetIn(_, ch) => collect_vars(left_of(ch)).concat(collect_vars(right_of(ch)))
        FnDef(_, _, ch) => collect_vars(left_of(ch))
    }

contains_var : Expr, Str -> Bool
contains_var = |expr, target|
    match expr {
        IntLit(_) => Bool.False
        Var(name) => name == target
        BinOp(_, ch) =>
            if contains_var(left_of(ch), target) Bool.True
            else contains_var(right_of(ch), target)
        Call(_, args) =>
            args.fold(Bool.False, |found, a| if found Bool.True else contains_var(a, target))
        Cond(p) =>
            if contains_var(left_of(p), target) Bool.True
            else if contains_var(right_of(p), target) Bool.True
            else contains_var(third_of(p), target)
        LetIn(_, ch) =>
            if contains_var(left_of(ch), target) Bool.True
            else contains_var(right_of(ch), target)
        FnDef(_, _, ch) => contains_var(left_of(ch), target)
    }

check! = |label, condition| {
    if condition {
        Stdout.line!("PASS: ${label}")
    } else {
        Stdout.line!("FAIL: ${label}")
    }
}

main! = || {
    v1 = collect_vars(int(42))
    check!("vars empty", v1 == [])
    v2 = collect_vars(ref("x"))
    check!("vars single", v2 == ["x"])
    v3 = collect_vars(add(ref("x"), ref("y")))
    check!("vars multi", v3 == ["x", "y"])
    v4 = collect_vars(let_in("x", ref("a"), add(ref("b"), ref("c"))))
    check!("vars letin", v4 == ["a", "b", "c"])
    c1 = contains_var(add(ref("x"), int(1)), "x")
    check!("contains yes", c1 == Bool.True)
    c2 = contains_var(add(ref("x"), int(1)), "y")
    check!("contains no", c2 == Bool.False)
    c3 = contains_var(int(42), "x")
    check!("contains leaf", c3 == Bool.False)
    Stdout.line!("--- 7 vars tests done ---")
}
