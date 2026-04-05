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
sub = |l, r| BinOp("-", [l, r])
mul = |l, r| BinOp("*", [l, r])
call = |name, args| Call(name, args)
if_then_else = |c, t, e| Cond([c, t, e])
let_in = |name, val, body| LetIn(name, [val, body])
fn_def = |name, params, body| FnDef(name, params, [body])

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

# --- Traversal functions (Expr -> scalar) ---

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

# --- Pretty printer (Expr -> Str) ---

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

# --- Constant folding (Expr -> Expr) ---

constant_fold : Expr -> Expr
constant_fold = |expr|
    match expr {
        BinOp(op, ch) => {
            l = constant_fold(left_of(ch))
            r = constant_fold(right_of(ch))
            match l {
                IntLit(lv) =>
                    match r {
                        IntLit(rv) =>
                            if op == "+" IntLit(lv + rv)
                            else if op == "-" IntLit(lv - rv)
                            else if op == "*" IntLit(lv * rv)
                            else BinOp(op, [l, r])
                        _ => BinOp(op, [l, r])
                    }
                _ => BinOp(op, [l, r])
            }
        }
        _ => expr
    }

# --- Tests ---

main! = || {
    # count_nodes
    r1 = count_nodes(int(42))
    check!("count IntLit", r1 == 1)
    r2 = count_nodes(ref("x"))
    check!("count Var", r2 == 1)
    r3 = count_nodes(add(int(1), int(2)))
    check!("count BinOp", r3 == 3)
    r4 = count_nodes(let_in("x", int(1), add(ref("x"), int(2))))
    check!("count LetIn", r4 == 5)
    r5 = count_nodes(call("f", []))
    check!("count Call empty", r5 == 1)
    r6 = count_nodes(call("f", [int(1), int(2)]))
    check!("count Call args", r6 == 3)
    r7 = count_nodes(if_then_else(ref("c"), int(1), int(2)))
    check!("count Cond", r7 == 4)
    r8 = count_nodes(fn_def("f", ["x"], add(ref("x"), int(1))))
    check!("count FnDef", r8 == 4)

    # depth
    d1 = depth(int(42))
    check!("depth leaf", d1 == 1)
    d2 = depth(add(int(1), int(2)))
    check!("depth 2", d2 == 2)
    d3 = depth(add(add(int(1), int(2)), int(3)))
    check!("depth 3", d3 == 3)

    # pretty printing
    p1 = expr_to_str(int(42))
    check!("pp int", p1 == "42")
    p2 = expr_to_str(ref("x"))
    check!("pp var", p2 == "x")
    p3 = expr_to_str(add(ref("x"), ref("y")))
    check!("pp binop", p3 == "(x + y)")
    p4 = expr_to_str(let_in("x", int(1), ref("x")))
    check!("pp letin", p4 == "let x = 1 in x")
    p5 = expr_to_str(fn_def("f", ["x", "y"], add(ref("x"), ref("y"))))
    check!("pp fndef", p5 == "fn f(x, y) (x + y)")
    p6 = expr_to_str(call("f", [int(1), int(2)]))
    check!("pp call", p6 == "f(1, 2)")
    p7 = expr_to_str(if_then_else(ref("c"), int(1), int(2)))
    check!("pp cond", p7 == "if c then 1 else 2")

    # constant folding via expr_eq
    f1_result = expr_to_str(constant_fold(add(int(1), int(2))))
    check!("fold add", f1_result == "3")
    f2_result = expr_to_str(constant_fold(mul(int(3), int(4))))
    check!("fold mul", f2_result == "12")
    f3_result = expr_to_str(constant_fold(sub(int(10), int(3))))
    check!("fold sub", f3_result == "7")
    f4_result = expr_to_str(constant_fold(add(ref("x"), int(1))))
    check!("fold no fold", f4_result == "(x + 1)")
    f5_result = expr_to_str(constant_fold(add(add(int(1), int(2)), int(4))))
    check!("fold nested", f5_result == "7")

    Stdout.line!("--- 25 tests done ---")

}
