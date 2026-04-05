app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

list_contains = |list, elem|
    list.fold(Bool.False, |found, item| if found Bool.True else (item == elem))

check! = |label, condition| {
    if condition {
        Stdout.line!("PASS: ${label}")
    } else {
        Stdout.line!("FAIL: ${label}")
    }
}

scope_lookup = |scopes, name|
    scope_lookup_at(scopes, name, 0, List.len(scopes))

scope_lookup_at = |scopes, name, idx, length|
    if idx >= length {
        Err(NotFound)
    } else {
        match scopes.get(idx) {
            Err(_) => Err(NotFound)
            Ok(scope) =>
                if list_contains(scope, name) Ok(idx)
                else scope_lookup_at(scopes, name, idx + 1, length)
        }
    }

main! = || {
    scopes = [["x", "y"], ["a", "b"]]
    l1 = scope_lookup(scopes, "x")
    check!("scope found 0", l1 == Ok(0))
    l2 = scope_lookup(scopes, "a")
    check!("scope found 1", l2 == Ok(1))
    l3 = scope_lookup(scopes, "z")
    check!("scope not found", l3 == Err(NotFound))
    l4 = scope_lookup([["x"], ["x", "y"]], "x")
    check!("scope shadow", l4 == Ok(0))
    Stdout.line!("--- 4 scope tests done ---")

}
