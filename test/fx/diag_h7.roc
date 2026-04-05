app [main!] { pf: platform "./platform/main.roc" }

import pf.Stdout

Chain := [End, Link(List(Chain))]

# What does length(End) actually do?
# Is the match correct when c = End?
describe : Chain -> Str
describe = |c|
    match c {
        End => "end"
        Link(_) => "link"
    }

# Check what List.first returns for a list containing End
main! = || {
    c_end : Chain
    c_end = End
    Stdout.line!("describe(End): ${describe(c_end)}")

    # Now get something out of a list
    mylist : List(Chain)
    mylist = [End]
    result = List.first(mylist)
    match result {
        Ok(elem) => Stdout.line!("first elem: ${describe(elem)}")
        Err(_) => Stdout.line!("no first")
    }
}
