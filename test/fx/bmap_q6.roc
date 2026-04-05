app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

# Q6: Two separate types -- A wraps B, B has List(A)
# Does the cross-type case hang?
A := [AEnd, ALink(B)]
B := [BNode(List(A))]

f_ab : A -> A
f_ab = |a|
    match a {
        AEnd => AEnd
        ALink(b) =>
            match b {
                BNode(children) =>
                    match List.first(children) {
                        Ok(next) => f_ab(next)
                        Err(_) => AEnd
                    }
            }
    }

main! = || {
    _r = f_ab(AEnd)
    Stdout.line!("Q6: ok")
}
