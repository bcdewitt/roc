app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Tests for: find_unresolved, scope_lookup (extended)

Expr := [
    IntLit(I64),
    Var(Str),
    BinOp(Str, List(Expr)),
    Call(Str, List(Expr)),
    Cond(List(Expr)),
    LetIn(Str, List(Expr)),
    FnDef(Str, List(Str), List(Expr)),
]

ref = |name| Var(name)
int = |n| IntLit(n)
add = |l, r| BinOp("+", [l, r])
let_in = |name, val, body| LetIn(name, [val, body])
fn_def = |name, params, body| FnDef(name, params, [body])

left_of = |list| list.first().ok_or(IntLit(0))
right_of = |list| list.get(1).ok_or(IntLit(0))
third_of = |list| list.get(2).ok_or(IntLit(0))

list_contains = |list, elem|
    list.fold(Bool.False, |found, item| if found Bool.True else (item == elem))

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

check! = |label, condition| {
    if condition {
        Stdout.line!("PASS: ${label}")
    } else {
        Stdout.line!("FAIL: ${label}")
    }
}

main! = || {
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
    Stdout.line!("--- 7 unresolved tests done ---")
}
