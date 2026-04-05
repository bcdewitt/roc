app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Tests for: map_expr

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
add = |l, r| BinOp("+", [l, r])

left_of = |list| list.first().ok_or(IntLit(0))
right_of = |list| list.get(1).ok_or(IntLit(0))
third_of = |list| list.get(2).ok_or(IntLit(0))

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

expr_eq = |a, b| expr_to_str(a) == expr_to_str(b)

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

check! = |label, condition| {
    if condition {
        Stdout.line!("PASS: ${label}")
    } else {
        Stdout.line!("FAIL: ${label}")
    }
}

main! = || {
    double_ints = |e|
        match e {
            IntLit(n) => IntLit(n * 2)
            other => other
        }
    m1 = expr_eq(map_expr(int(5), double_ints), int(10))
    check!("map int", m1)
    m2 = expr_eq(map_expr(add(int(1), int(2)), double_ints), add(int(2), int(4)))
    check!("map binop", m2)
    Stdout.line!("--- 2 map tests done ---")
}
