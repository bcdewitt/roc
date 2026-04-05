app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# MINIMAL REPRODUCTION:
# Recursive call in the ELSE branch of an if/else
# inside a match arm of a recursive nominal type
# → stack overflow at runtime (both dev and LLVM backends)
#
# Moving the recursive call to the THEN branch (by negating
# the condition) makes it work correctly.

T := [A(I64), B(Str, List(T))]

to_str : T -> Str
to_str = |t|
    match t {
        A(n) => n.to_str()
        B(name, ch) => "${name}(${ch.map(|c| to_str(c)).join_with(", ")})"
    }

# TWO recursive calls inside constructor in else branch
f : T -> T
f = |t|
    match t {
        A(n) => A(n * 2)
        B(name, ch) =>
            if name == "stop" {
                A(99)
            } else {
                B(name, [f(ch.first().ok_or(A(0))), f(ch.get(1).ok_or(A(0)))])
            }
    }

main! = || {
    input = B("go", [A(42)])

    Stdout.line!("calling f...")
    r = f(input)
    Stdout.line!("result: ${to_str(r)}")
    Stdout.line!("done")
}
