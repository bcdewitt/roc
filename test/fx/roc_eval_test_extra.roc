app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

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

left_of = |list| list.first().ok_or(IntLit(0))
right_of = |list| list.get(1).ok_or(IntLit(0))
third_of = |list| list.get(2).ok_or(IntLit(0))

max = |a, b| if a >= b a else b

check! = |label, condition| {
    if condition {
        Stdout.line!("PASS: ${label}")
    } else {
        Stdout.line!("FAIL: ${label}")
    }
}

expr_to_str : Expr -> Str
expr_to_str = |expr|
    match expr {
        IntLit(n) => n.to_str()
        Var(name) => name
        BinOp(op, ch) =>
            "(${expr_to_str(left_of(ch))} ${op} ${expr_to_str(right_of(ch))})"
        Call(name, args) =>
            "${name}(${args.map(|a| expr_to_str(a)).join_with(", ")})"
        Cond(parts) =>
            "if ${expr_to_str(left_of(parts))} then ${expr_to_str(right_of(parts))} else ${expr_to_str(third_of(parts))}"
        LetIn(name, ch) =>
            "let ${name} = ${expr_to_str(left_of(ch))} in ${expr_to_str(right_of(ch))}"
        FnDef(name, params, ch) =>
            "fn ${name}(${params.join_with(", ")}) ${expr_to_str(left_of(ch))}"
    }

# --- map_expr: higher-order tree transformation ---

map_expr : Expr, (Expr -> Expr) -> Expr
map_expr = |expr, f| {
    transformed = match expr {
        IntLit(_) => expr
        Var(_) => expr
        BinOp(op, ch) => BinOp(op, [map_expr(left_of(ch), f), map_expr(right_of(ch), f)])
        Call(name, args) => Call(name, args.map(|a| map_expr(a, f)))
        Cond(p) => Cond([map_expr(left_of(p), f), map_expr(right_of(p), f), map_expr(third_of(p), f)])
        LetIn(name, ch) => LetIn(name, [map_expr(left_of(ch), f), map_expr(right_of(ch), f)])
        FnDef(name, params, ch) => FnDef(name, params, [map_expr(left_of(ch), f)])
    }
    f(transformed)
}

# --- Mutual recursion ---

is_even = |n|
    if n == 0 Bool.True
    else is_odd(n - 1)

is_odd = |n|
    if n == 0 Bool.False
    else is_even(n - 1)

# --- Deep nesting ---

build_chain : I64 -> Expr
build_chain = |n|
    if n <= 0 int(0)
    else add(int(n), build_chain(n - 1))

count_nodes : Expr -> I64
count_nodes = |expr|
    match expr {
        IntLit(_) => 1
        Var(_) => 1
        BinOp(_, ch) => 1 + count_nodes(left_of(ch)) + count_nodes(right_of(ch))
        Call(_, args) => 1 + args.fold(0, |acc, a| acc + count_nodes(a))
        Cond(p) => 1 + count_nodes(left_of(p)) + count_nodes(right_of(p)) + count_nodes(third_of(p))
        LetIn(_, ch) => 1 + count_nodes(left_of(ch)) + count_nodes(right_of(ch))
        FnDef(_, _, ch) => 1 + count_nodes(left_of(ch))
    }

depth : Expr -> I64
depth = |expr|
    match expr {
        IntLit(_) => 1
        Var(_) => 1
        BinOp(_, ch) => 1 + max(depth(left_of(ch)), depth(right_of(ch)))
        Call(_, args) => 1 + args.fold(0, |acc, a| max(acc, depth(a)))
        Cond(p) => 1 + max(depth(left_of(p)), max(depth(right_of(p)), depth(third_of(p))))
        LetIn(_, ch) => 1 + max(depth(left_of(ch)), depth(right_of(ch)))
        FnDef(_, _, ch) => 1 + depth(left_of(ch))
    }

# --- Tests ---

main! = || {
    # mutual recursion
    e1 = is_even(0)
    check!("even 0", e1 == Bool.True)
    e2 = is_even(4)
    check!("even 4", e2 == Bool.True)
    e3 = is_even(3)
    check!("even 3", e3 == Bool.False)
    o1 = is_odd(3)
    check!("odd 3", o1 == Bool.True)
    o2 = is_odd(4)
    check!("odd 4", o2 == Bool.False)

    # build_chain + count/depth
    bc = count_nodes(build_chain(10))
    check!("chain count", bc == 21)
    bd = depth(build_chain(10))
    check!("chain depth", bd == 11)

    Stdout.line!("--- 7 tests done ---")

}
