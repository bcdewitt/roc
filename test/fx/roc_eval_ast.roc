app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# ============================================================
# AST Type Definition
# ============================================================
# Recursive types require nominal (:=) definition in Roc.
# Direct multi-field recursion (Node(Expr, Expr)) segfaults in
# the current nightly — List(Expr) works because List handles
# boxing internally.
#
# == on recursive nominal types fails in `roc test` (compiler
# bug), so tests compare via expr_to_str instead.

Expr := [
    IntLit(I64),
    Var(Str),
    BinOp(Str, List(Expr)),
    Call(Str, List(Expr)),
    Cond(List(Expr)),
    LetIn(Str, List(Expr)),
    FnDef(Str, List(Str), List(Expr)),
]

# ============================================================
# Constructors
# ============================================================

int = |n| IntLit(n)
ref = |name| Var(name)
add = |l, r| BinOp("+", [l, r])
sub = |l, r| BinOp("-", [l, r])
mul = |l, r| BinOp("*", [l, r])
eq_op = |l, r| BinOp("==", [l, r])
call = |name, args| Call(name, args)
if_then_else = |c, t, e| Cond([c, t, e])
let_in = |name, val, body| LetIn(name, [val, body])
fn_def = |name, params, body| FnDef(name, params, [body])

# ============================================================
# Internal accessors
# ============================================================

left_of = |list| list.first().ok_or(IntLit(0))
right_of = |list| list.get(1).ok_or(IntLit(0))
third_of = |list| list.get(2).ok_or(IntLit(0))

# ============================================================
# Helpers
# ============================================================

max = |a, b| if a >= b a else b

list_contains = |list, elem|
    list.fold(Bool.False, |found, item| if found Bool.True else (item == elem))

# ============================================================
# Pretty Printer (also used for test equality)
# ============================================================

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

# Compare expressions via string representation
expr_eq = |a, b| expr_to_str(a) == expr_to_str(b)

# ============================================================
# Tree Traversal
# ============================================================

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

# ============================================================
# Tree Transformation
# ============================================================

substitute : Expr, Str, Expr -> Expr
substitute = |expr, target, replacement|
    match expr {
        IntLit(_) => expr
        Var(name) => if name == target replacement else expr
        BinOp(op, ch) =>
            BinOp(op, [substitute(left_of(ch), target, replacement), substitute(right_of(ch), target, replacement)])
        Call(name, args) =>
            Call(name, args.map(|a| substitute(a, target, replacement)))
        Cond(p) =>
            Cond([substitute(left_of(p), target, replacement), substitute(right_of(p), target, replacement), substitute(third_of(p), target, replacement)])
        LetIn(name, ch) =>
            if name == target {
                # Shadowed: substitute in value only, not body
                LetIn(name, [substitute(left_of(ch), target, replacement), right_of(ch)])
            } else {
                LetIn(name, [substitute(left_of(ch), target, replacement), substitute(right_of(ch), target, replacement)])
            }
        FnDef(name, params, ch) =>
            if list_contains(params, target) {
                # Parameter shadows target
                expr
            } else {
                FnDef(name, params, [substitute(left_of(ch), target, replacement)])
            }
    }

constant_fold : Expr -> Expr
constant_fold = |expr|
    match expr {
        IntLit(_) => expr
        Var(_) => expr
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
        Call(name, args) => Call(name, args.map(|a| constant_fold(a)))
        Cond(p) => Cond([constant_fold(left_of(p)), constant_fold(right_of(p)), constant_fold(third_of(p))])
        LetIn(name, ch) => LetIn(name, [constant_fold(left_of(ch)), constant_fold(right_of(ch))])
        FnDef(name, params, ch) => FnDef(name, params, [constant_fold(left_of(ch))])
    }

# Bottom-up tree map: transform children first, then apply f to result
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

# ============================================================
# Symbol Resolution
# ============================================================

scope_lookup = |scopes, name|
    scope_lookup_at(scopes, name, 0)

scope_lookup_at = |scopes, name, idx|
    match scopes.get(idx) {
        Err(_) => Err(NotFound)
        Ok(scope) =>
            if list_contains(scope, name) Ok(idx)
            else scope_lookup_at(scopes, name, idx + 1)
    }

find_unresolved : Expr, List(List(Str)) -> List(Str)
find_unresolved = |expr, scopes|
    match expr {
        IntLit(_) => []
        Var(name) =>
            match scope_lookup(scopes, name) {
                Ok(_) => []
                Err(_) => [name]
            }
        BinOp(_, ch) =>
            find_unresolved(left_of(ch), scopes).concat(find_unresolved(right_of(ch), scopes))
        Call(_, args) =>
            args.fold([], |acc, a| acc.concat(find_unresolved(a, scopes)))
        Cond(p) =>
            find_unresolved(left_of(p), scopes)
                .concat(find_unresolved(right_of(p), scopes))
                .concat(find_unresolved(third_of(p), scopes))
        LetIn(name, ch) => {
            val_unresolved = find_unresolved(left_of(ch), scopes)
            new_scopes = [[name]].concat(scopes)
            body_unresolved = find_unresolved(right_of(ch), new_scopes)
            val_unresolved.concat(body_unresolved)
        }
        FnDef(_, params, ch) => {
            new_scopes = [params].concat(scopes)
            find_unresolved(left_of(ch), new_scopes)
        }
    }

# ============================================================
# Mutual Recursion
# ============================================================

is_even = |n|
    if n == 0 Bool.True
    else is_odd(n - 1)

is_odd = |n|
    if n == 0 Bool.False
    else is_even(n - 1)

# ============================================================
# Deep Nesting Builder
# ============================================================

build_chain : I64 -> Expr
build_chain = |n|
    if n <= 0 int(0)
    else add(int(n), build_chain(n - 1))

# ============================================================
# Expect Tests (subset that fits within roc test stack limit)
# Full test suite runs via main! (roc run)
# Expect tests removed — they cause compiler stack overflow with
# this many recursive functions in one file.
# ============================================================

# ============================================================
# Test Helper
# ============================================================

check! = |label, condition| {
    if condition {
        Stdout.line!("PASS: ${label}")
    } else {
        Stdout.line!("FAIL: ${label}")
    }
}

# ============================================================
# Main — split into batches to work around codegen segfault
# ============================================================

test_counting! = |_| {
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
    d1 = depth(int(42))
    check!("depth leaf", d1 == 1)
    d2 = depth(add(int(1), int(2)))
    check!("depth 2", d2 == 2)
    d3 = depth(add(add(int(1), int(2)), int(3)))
    check!("depth 3", d3 == 3)
    {}
}

test_vars! = |_| {
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
    {}
}

test_substitution! = |_| {
    s1 = expr_eq(substitute(ref("x"), "x", int(42)), int(42))
    check!("sub match", s1)
    s2 = expr_eq(substitute(ref("y"), "x", int(42)), ref("y"))
    check!("sub no match", s2)
    s3 = expr_eq(substitute(add(ref("x"), ref("y")), "x", int(1)), add(int(1), ref("y")))
    check!("sub binop", s3)
    s4 = expr_eq(substitute(let_in("x", ref("x"), ref("x")), "x", int(99)), let_in("x", int(99), ref("x")))
    check!("sub shadow let", s4)
    s5 = expr_eq(substitute(let_in("y", ref("x"), ref("x")), "x", int(99)), let_in("y", int(99), int(99)))
    check!("sub no shadow", s5)
    s6 = expr_eq(substitute(fn_def("f", ["x"], add(ref("x"), ref("y"))), "x", int(99)), fn_def("f", ["x"], add(ref("x"), ref("y"))))
    check!("sub shadow fn", s6)
    s7 = expr_eq(substitute(fn_def("f", ["a"], add(ref("x"), ref("y"))), "x", int(99)), fn_def("f", ["a"], add(int(99), ref("y"))))
    check!("sub fn no shadow", s7)
    {}
}

test_folding! = |_| {
    f1 = expr_eq(constant_fold(add(int(1), int(2))), int(3))
    check!("fold add", f1)
    f2 = expr_eq(constant_fold(mul(int(3), int(4))), int(12))
    check!("fold mul", f2)
    f3 = expr_eq(constant_fold(sub(int(10), int(3))), int(7))
    check!("fold sub", f3)
    f4 = expr_eq(constant_fold(add(ref("x"), int(1))), add(ref("x"), int(1)))
    check!("fold no fold", f4)
    f5 = expr_eq(constant_fold(add(add(int(1), int(2)), int(4))), int(7))
    check!("fold nested", f5)
    {}
}

test_map_and_pp! = |_| {
    double_ints = |e|
        match e {
            IntLit(n) => IntLit(n * 2)
            other => other
        }
    m1 = expr_eq(map_expr(int(5), double_ints), int(10))
    check!("map int", m1)
    m2 = expr_eq(map_expr(add(int(1), int(2)), double_ints), add(int(2), int(4)))
    check!("map binop", m2)
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
    {}
}

test_scopes! = |_| {
    scopes = [["x", "y"], ["a", "b"]]
    l1 = scope_lookup(scopes, "x")
    check!("scope found 0", l1 == Ok(0))
    l2 = scope_lookup(scopes, "a")
    check!("scope found 1", l2 == Ok(1))
    l3 = scope_lookup(scopes, "z")
    check!("scope not found", l3 == Err(NotFound))
    l4 = scope_lookup([["x"], ["x", "y"]], "x")
    check!("scope shadow", l4 == Ok(0))
    u1 = find_unresolved(ref("x"), [["x"]])
    check!("unres resolved", u1 == [])
    u2 = find_unresolved(ref("x"), [])
    check!("unres bare", u2 == ["x"])
    u3 = find_unresolved(add(ref("x"), ref("y")), [["x"]])
    check!("unres partial", u3 == ["y"])
    u4 = find_unresolved(let_in("x", int(1), add(ref("x"), ref("y"))), [])
    check!("unres letin scope", u4 == ["y"])
    u5 = find_unresolved(fn_def("f", ["a", "b"], add(ref("a"), ref("c"))), [])
    check!("unres fn params", u5 == ["c"])
    u6 = find_unresolved(let_in("x", int(1), let_in("y", int(2), add(add(ref("x"), ref("y")), ref("z")))), [])
    check!("unres nested", u6 == ["z"])
    u7 = find_unresolved(add(ref("x"), ref("y")), [["x", "y"]])
    check!("unres all resolved", u7 == [])
    {}
}

test_misc! = |_| {
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
    bc = count_nodes(build_chain(10))
    check!("chain count", bc == 21)
    bd = depth(build_chain(10))
    check!("chain depth", bd == 11)
    {}
}

main! = || {
    test_counting!({})
    test_vars!({})
    test_substitution!({})
    test_folding!({})
    test_map_and_pp!({})
    test_scopes!({})
    test_misc!({})
    Stdout.line!("--- all 57 tests done ---")

}
