# META
~~~ini
description=Regression test: many functions on recursive nominal type should not cause stack overflow during compilation
type=snippet
~~~
# SOURCE
~~~roc
Tree := [Leaf(I64), Node(List(Tree))]

count : Tree -> I64
count = |t|
	match t {
		Leaf(_) => 1
		Node(children) =>
			List.fold(children, 1, |acc, c| acc + count(c))
	}

depth : Tree -> I64
depth = |t|
	match t {
		Leaf(_) => 0
		Node(children) =>
			List.fold(children, 0, |acc, c| {
				d = depth(c)
				if d > acc d else acc
			}) + 1
	}

sum : Tree -> I64
sum = |t|
	match t {
		Leaf(v) => v
		Node(children) =>
			List.fold(children, 0, |acc, c| acc + sum(c))
	}

max_val : Tree -> I64
max_val = |t|
	match t {
		Leaf(v) => v
		Node(children) =>
			List.fold(children, 0, |acc, c| {
				v = max_val(c)
				if v > acc v else acc
			})
	}

map_leaves : Tree, (I64 -> I64) -> Tree
map_leaves = |t, f|
	match t {
		Leaf(v) => Leaf(f(v))
		Node(children) =>
			Node(List.map(children, |c| map_leaves(c, f)))
	}

leaf_count : Tree -> I64
leaf_count = |t|
	match t {
		Leaf(_) => 1
		Node(children) =>
			List.fold(children, 0, |acc, c| acc + leaf_count(c))
	}

contains : Tree, I64 -> Bool
contains = |t, target|
	match t {
		Leaf(v) => v == target
		Node(children) =>
			List.any(children, |c| contains(c, target))
	}

flatten : Tree -> List(I64)
flatten = |t|
	match t {
		Leaf(v) => [v]
		Node(children) =>
			List.fold(children, [], |acc, c| List.concat(acc, flatten(c)))
	}

my_tree : Tree
my_tree = Node([Node([Leaf(1), Leaf(2)]), Leaf(3)])

expect count(my_tree) == 5
expect depth(my_tree) == 2
expect sum(my_tree) == 6
expect max_val(my_tree) == 3
expect leaf_count(my_tree) == 3
expect contains(my_tree, 2) == True
expect contains(my_tree, 99) == False
expect flatten(my_tree) == [1, 2, 3]
~~~
# EXPECTED
NIL
# PROBLEMS
NIL
# TOKENS
~~~zig
UpperIdent,OpColonEqual,OpenSquare,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,CloseRound,CloseSquare,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,Underscore,CloseRound,OpFatArrow,Int,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,LowerIdent,OpPlus,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,Underscore,CloseRound,OpFatArrow,Int,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,OpenCurly,
LowerIdent,OpAssign,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,
KwIf,LowerIdent,OpGreaterThan,LowerIdent,LowerIdent,KwElse,LowerIdent,
CloseCurly,CloseRound,OpPlus,Int,
CloseCurly,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,LowerIdent,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,LowerIdent,OpPlus,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,LowerIdent,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,OpenCurly,
LowerIdent,OpAssign,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,
KwIf,LowerIdent,OpGreaterThan,LowerIdent,LowerIdent,KwElse,LowerIdent,
CloseCurly,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,Comma,OpenRound,UpperIdent,OpArrow,UpperIdent,CloseRound,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,Comma,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,UpperIdent,NoSpaceOpenRound,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,CloseRound,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceOpenRound,UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,OpBar,LowerIdent,OpBar,LowerIdent,NoSpaceOpenRound,LowerIdent,Comma,LowerIdent,CloseRound,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,Underscore,CloseRound,OpFatArrow,Int,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,LowerIdent,OpPlus,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,Comma,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,Comma,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,LowerIdent,OpEquals,LowerIdent,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,OpBar,LowerIdent,OpBar,LowerIdent,NoSpaceOpenRound,LowerIdent,Comma,LowerIdent,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,OpenSquare,LowerIdent,CloseSquare,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,OpenSquare,CloseSquare,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,
LowerIdent,OpAssign,UpperIdent,NoSpaceOpenRound,OpenSquare,UpperIdent,NoSpaceOpenRound,OpenSquare,UpperIdent,NoSpaceOpenRound,Int,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,Int,CloseRound,CloseSquare,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,Int,CloseRound,CloseSquare,CloseRound,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpEquals,Int,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpEquals,Int,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpEquals,Int,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpEquals,Int,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpEquals,Int,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,CloseRound,OpEquals,UpperIdent,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,CloseRound,OpEquals,UpperIdent,
KwExpect,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpEquals,OpenSquare,Int,Comma,Int,Comma,Int,CloseSquare,
EndOfFile,
~~~
# PARSE
~~~clojure
(file
	(type-module)
	(statements
		(s-type-decl
			(header (name "Tree")
				(args))
			(ty-tag-union
				(tags
					(ty-apply
						(ty (name "Leaf"))
						(ty (name "I64")))
					(ty-apply
						(ty (name "Node"))
						(ty-apply
							(ty (name "List"))
							(ty (name "Tree")))))))
		(s-type-anno (name "count")
			(ty-fn
				(ty (name "Tree"))
				(ty (name "I64"))))
		(s-decl
			(p-ident (raw "count"))
			(e-lambda
				(args
					(p-ident (raw "t")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-underscore))
							(e-int (raw "1")))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-apply
								(e-ident (raw "List.fold"))
								(e-ident (raw "children"))
								(e-int (raw "1"))
								(e-lambda
									(args
										(p-ident (raw "acc"))
										(p-ident (raw "c")))
									(e-binop (op "+")
										(e-ident (raw "acc"))
										(e-apply
											(e-ident (raw "count"))
											(e-ident (raw "c")))))))))))
		(s-type-anno (name "depth")
			(ty-fn
				(ty (name "Tree"))
				(ty (name "I64"))))
		(s-decl
			(p-ident (raw "depth"))
			(e-lambda
				(args
					(p-ident (raw "t")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-underscore))
							(e-int (raw "0")))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-binop (op "+")
								(e-apply
									(e-ident (raw "List.fold"))
									(e-ident (raw "children"))
									(e-int (raw "0"))
									(e-lambda
										(args
											(p-ident (raw "acc"))
											(p-ident (raw "c")))
										(e-block
											(statements
												(s-decl
													(p-ident (raw "d"))
													(e-apply
														(e-ident (raw "depth"))
														(e-ident (raw "c"))))
												(e-if-then-else
													(e-binop (op ">")
														(e-ident (raw "d"))
														(e-ident (raw "acc")))
													(e-ident (raw "d"))
													(e-ident (raw "acc")))))))
								(e-int (raw "1"))))))))
		(s-type-anno (name "sum")
			(ty-fn
				(ty (name "Tree"))
				(ty (name "I64"))))
		(s-decl
			(p-ident (raw "sum"))
			(e-lambda
				(args
					(p-ident (raw "t")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-ident (raw "v")))
							(e-ident (raw "v")))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-apply
								(e-ident (raw "List.fold"))
								(e-ident (raw "children"))
								(e-int (raw "0"))
								(e-lambda
									(args
										(p-ident (raw "acc"))
										(p-ident (raw "c")))
									(e-binop (op "+")
										(e-ident (raw "acc"))
										(e-apply
											(e-ident (raw "sum"))
											(e-ident (raw "c")))))))))))
		(s-type-anno (name "max_val")
			(ty-fn
				(ty (name "Tree"))
				(ty (name "I64"))))
		(s-decl
			(p-ident (raw "max_val"))
			(e-lambda
				(args
					(p-ident (raw "t")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-ident (raw "v")))
							(e-ident (raw "v")))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-apply
								(e-ident (raw "List.fold"))
								(e-ident (raw "children"))
								(e-int (raw "0"))
								(e-lambda
									(args
										(p-ident (raw "acc"))
										(p-ident (raw "c")))
									(e-block
										(statements
											(s-decl
												(p-ident (raw "v"))
												(e-apply
													(e-ident (raw "max_val"))
													(e-ident (raw "c"))))
											(e-if-then-else
												(e-binop (op ">")
													(e-ident (raw "v"))
													(e-ident (raw "acc")))
												(e-ident (raw "v"))
												(e-ident (raw "acc"))))))))))))
		(s-type-anno (name "map_leaves")
			(ty-fn
				(ty (name "Tree"))
				(ty-fn
					(ty (name "I64"))
					(ty (name "I64")))
				(ty (name "Tree"))))
		(s-decl
			(p-ident (raw "map_leaves"))
			(e-lambda
				(args
					(p-ident (raw "t"))
					(p-ident (raw "f")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-ident (raw "v")))
							(e-apply
								(e-tag (raw "Leaf"))
								(e-apply
									(e-ident (raw "f"))
									(e-ident (raw "v")))))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-apply
								(e-tag (raw "Node"))
								(e-apply
									(e-ident (raw "List.map"))
									(e-ident (raw "children"))
									(e-lambda
										(args
											(p-ident (raw "c")))
										(e-apply
											(e-ident (raw "map_leaves"))
											(e-ident (raw "c"))
											(e-ident (raw "f")))))))))))
		(s-type-anno (name "leaf_count")
			(ty-fn
				(ty (name "Tree"))
				(ty (name "I64"))))
		(s-decl
			(p-ident (raw "leaf_count"))
			(e-lambda
				(args
					(p-ident (raw "t")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-underscore))
							(e-int (raw "1")))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-apply
								(e-ident (raw "List.fold"))
								(e-ident (raw "children"))
								(e-int (raw "0"))
								(e-lambda
									(args
										(p-ident (raw "acc"))
										(p-ident (raw "c")))
									(e-binop (op "+")
										(e-ident (raw "acc"))
										(e-apply
											(e-ident (raw "leaf_count"))
											(e-ident (raw "c")))))))))))
		(s-type-anno (name "contains")
			(ty-fn
				(ty (name "Tree"))
				(ty (name "I64"))
				(ty (name "Bool"))))
		(s-decl
			(p-ident (raw "contains"))
			(e-lambda
				(args
					(p-ident (raw "t"))
					(p-ident (raw "target")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-ident (raw "v")))
							(e-binop (op "==")
								(e-ident (raw "v"))
								(e-ident (raw "target"))))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-apply
								(e-ident (raw "List.any"))
								(e-ident (raw "children"))
								(e-lambda
									(args
										(p-ident (raw "c")))
									(e-apply
										(e-ident (raw "contains"))
										(e-ident (raw "c"))
										(e-ident (raw "target"))))))))))
		(s-type-anno (name "flatten")
			(ty-fn
				(ty (name "Tree"))
				(ty-apply
					(ty (name "List"))
					(ty (name "I64")))))
		(s-decl
			(p-ident (raw "flatten"))
			(e-lambda
				(args
					(p-ident (raw "t")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-ident (raw "v")))
							(e-list
								(e-ident (raw "v"))))
						(branch
							(p-tag (raw "Node")
								(p-ident (raw "children")))
							(e-apply
								(e-ident (raw "List.fold"))
								(e-ident (raw "children"))
								(e-list)
								(e-lambda
									(args
										(p-ident (raw "acc"))
										(p-ident (raw "c")))
									(e-apply
										(e-ident (raw "List.concat"))
										(e-ident (raw "acc"))
										(e-apply
											(e-ident (raw "flatten"))
											(e-ident (raw "c")))))))))))
		(s-type-anno (name "my_tree")
			(ty (name "Tree")))
		(s-decl
			(p-ident (raw "my_tree"))
			(e-apply
				(e-tag (raw "Node"))
				(e-list
					(e-apply
						(e-tag (raw "Node"))
						(e-list
							(e-apply
								(e-tag (raw "Leaf"))
								(e-int (raw "1")))
							(e-apply
								(e-tag (raw "Leaf"))
								(e-int (raw "2")))))
					(e-apply
						(e-tag (raw "Leaf"))
						(e-int (raw "3"))))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "count"))
					(e-ident (raw "my_tree")))
				(e-int (raw "5"))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "depth"))
					(e-ident (raw "my_tree")))
				(e-int (raw "2"))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "sum"))
					(e-ident (raw "my_tree")))
				(e-int (raw "6"))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "max_val"))
					(e-ident (raw "my_tree")))
				(e-int (raw "3"))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "leaf_count"))
					(e-ident (raw "my_tree")))
				(e-int (raw "3"))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "contains"))
					(e-ident (raw "my_tree"))
					(e-int (raw "2")))
				(e-tag (raw "True"))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "contains"))
					(e-ident (raw "my_tree"))
					(e-int (raw "99")))
				(e-tag (raw "False"))))
		(s-expect
			(e-binop (op "==")
				(e-apply
					(e-ident (raw "flatten"))
					(e-ident (raw "my_tree")))
				(e-list
					(e-int (raw "1"))
					(e-int (raw "2"))
					(e-int (raw "3")))))))
~~~
# FORMATTED
~~~roc
Tree := [Leaf(I64), Node(List(Tree))]

count : Tree -> I64
count = |t|
	match t {
		Leaf(_) => 1
		Node(children) =>
			List.fold(children, 1, |acc, c| acc + count(c))
		}

depth : Tree -> I64
depth = |t|
	match t {
		Leaf(_) => 0
		Node(children) =>
			List.fold(
				children,
				0,
				|acc, c| {
					d = depth(c)
					if d > acc d else acc
				},
			) + 1
		}

sum : Tree -> I64
sum = |t|
	match t {
		Leaf(v) => v
		Node(children) =>
			List.fold(children, 0, |acc, c| acc + sum(c))
		}

max_val : Tree -> I64
max_val = |t|
	match t {
		Leaf(v) => v
		Node(children) =>
			List.fold(
				children,
				0,
				|acc, c| {
					v = max_val(c)
					if v > acc v else acc
				},
			)
		}

map_leaves : Tree, (I64 -> I64) -> Tree
map_leaves = |t, f|
	match t {
		Leaf(v) => Leaf(f(v))
		Node(children) =>
			Node(List.map(children, |c| map_leaves(c, f)))
		}

leaf_count : Tree -> I64
leaf_count = |t|
	match t {
		Leaf(_) => 1
		Node(children) =>
			List.fold(children, 0, |acc, c| acc + leaf_count(c))
		}

contains : Tree, I64 -> Bool
contains = |t, target|
	match t {
		Leaf(v) => v == target
		Node(children) =>
			List.any(children, |c| contains(c, target))
		}

flatten : Tree -> List(I64)
flatten = |t|
	match t {
		Leaf(v) => [v]
		Node(children) =>
			List.fold(children, [], |acc, c| List.concat(acc, flatten(c)))
		}

my_tree : Tree
my_tree = Node([Node([Leaf(1), Leaf(2)]), Leaf(3)])

expect count(my_tree) == 5
expect depth(my_tree) == 2
expect sum(my_tree) == 6
expect max_val(my_tree) == 3
expect leaf_count(my_tree) == 3
expect contains(my_tree, 2) == True
expect contains(my_tree, 99) == False
expect flatten(my_tree) == [1, 2, 3]
~~~
# CANONICALIZE
~~~clojure
(can-ir
	(d-let
		(p-assign (ident "count"))
		(e-lambda
			(args
				(p-assign (ident "t")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-num (value "1"))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-call
									(e-lookup-external
										(builtin))
									(e-lookup-local
										(p-assign (ident "children")))
									(e-num (value "1"))
									(e-lambda
										(args
											(p-assign (ident "acc"))
											(p-assign (ident "c")))
										(e-binop (op "add")
											(e-lookup-local
												(p-assign (ident "acc")))
											(e-call
												(e-lookup-local
													(p-assign (ident "count")))
												(e-lookup-local
													(p-assign (ident "c")))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin)))))
	(d-let
		(p-assign (ident "depth"))
		(e-lambda
			(args
				(p-assign (ident "t")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-num (value "0"))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-binop (op "add")
									(e-call
										(e-lookup-external
											(builtin))
										(e-lookup-local
											(p-assign (ident "children")))
										(e-num (value "0"))
										(e-lambda
											(args
												(p-assign (ident "acc"))
												(p-assign (ident "c")))
											(e-block
												(s-let
													(p-assign (ident "d"))
													(e-call
														(e-lookup-local
															(p-assign (ident "depth")))
														(e-lookup-local
															(p-assign (ident "c")))))
												(e-if
													(if-branches
														(if-branch
															(e-binop (op "gt")
																(e-lookup-local
																	(p-assign (ident "d")))
																(e-lookup-local
																	(p-assign (ident "acc"))))
															(e-lookup-local
																(p-assign (ident "d")))))
													(if-else
														(e-lookup-local
															(p-assign (ident "acc"))))))))
									(e-num (value "1")))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin)))))
	(d-let
		(p-assign (ident "sum"))
		(e-lambda
			(args
				(p-assign (ident "t")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-lookup-local
									(p-assign (ident "v")))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-call
									(e-lookup-external
										(builtin))
									(e-lookup-local
										(p-assign (ident "children")))
									(e-num (value "0"))
									(e-lambda
										(args
											(p-assign (ident "acc"))
											(p-assign (ident "c")))
										(e-binop (op "add")
											(e-lookup-local
												(p-assign (ident "acc")))
											(e-call
												(e-lookup-local
													(p-assign (ident "sum")))
												(e-lookup-local
													(p-assign (ident "c")))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin)))))
	(d-let
		(p-assign (ident "max_val"))
		(e-lambda
			(args
				(p-assign (ident "t")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-lookup-local
									(p-assign (ident "v")))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-call
									(e-lookup-external
										(builtin))
									(e-lookup-local
										(p-assign (ident "children")))
									(e-num (value "0"))
									(e-lambda
										(args
											(p-assign (ident "acc"))
											(p-assign (ident "c")))
										(e-block
											(s-let
												(p-assign (ident "v"))
												(e-call
													(e-lookup-local
														(p-assign (ident "max_val")))
													(e-lookup-local
														(p-assign (ident "c")))))
											(e-if
												(if-branches
													(if-branch
														(e-binop (op "gt")
															(e-lookup-local
																(p-assign (ident "v")))
															(e-lookup-local
																(p-assign (ident "acc"))))
														(e-lookup-local
															(p-assign (ident "v")))))
												(if-else
													(e-lookup-local
														(p-assign (ident "acc"))))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin)))))
	(d-let
		(p-assign (ident "map_leaves"))
		(e-lambda
			(args
				(p-assign (ident "t"))
				(p-assign (ident "f")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-tag (name "Leaf")
									(args
										(e-call
											(e-lookup-local
												(p-assign (ident "f")))
											(e-lookup-local
												(p-assign (ident "v"))))))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-tag (name "Node")
									(args
										(e-call
											(e-lookup-external
												(builtin))
											(e-lookup-local
												(p-assign (ident "children")))
											(e-closure
												(captures
													(capture (ident "f")))
												(e-lambda
													(args
														(p-assign (ident "c")))
													(e-call
														(e-lookup-local
															(p-assign (ident "map_leaves")))
														(e-lookup-local
															(p-assign (ident "c")))
														(e-lookup-local
															(p-assign (ident "f")))))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-parens
					(ty-fn (effectful false)
						(ty-lookup (name "I64") (builtin))
						(ty-lookup (name "I64") (builtin))))
				(ty-lookup (name "Tree") (local)))))
	(d-let
		(p-assign (ident "leaf_count"))
		(e-lambda
			(args
				(p-assign (ident "t")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-num (value "1"))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-call
									(e-lookup-external
										(builtin))
									(e-lookup-local
										(p-assign (ident "children")))
									(e-num (value "0"))
									(e-lambda
										(args
											(p-assign (ident "acc"))
											(p-assign (ident "c")))
										(e-binop (op "add")
											(e-lookup-local
												(p-assign (ident "acc")))
											(e-call
												(e-lookup-local
													(p-assign (ident "leaf_count")))
												(e-lookup-local
													(p-assign (ident "c")))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin)))))
	(d-let
		(p-assign (ident "contains"))
		(e-lambda
			(args
				(p-assign (ident "t"))
				(p-assign (ident "target")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-binop (op "eq")
									(e-lookup-local
										(p-assign (ident "v")))
									(e-lookup-local
										(p-assign (ident "target"))))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-call
									(e-lookup-external
										(builtin))
									(e-lookup-local
										(p-assign (ident "children")))
									(e-closure
										(captures
											(capture (ident "target")))
										(e-lambda
											(args
												(p-assign (ident "c")))
											(e-call
												(e-lookup-local
													(p-assign (ident "contains")))
												(e-lookup-local
													(p-assign (ident "c")))
												(e-lookup-local
													(p-assign (ident "target")))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin))
				(ty-lookup (name "Bool") (builtin)))))
	(d-let
		(p-assign (ident "flatten"))
		(e-lambda
			(args
				(p-assign (ident "t")))
			(e-match
				(match
					(cond
						(e-lookup-local
							(p-assign (ident "t"))))
					(branches
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-list
									(elems
										(e-lookup-local
											(p-assign (ident "v")))))))
						(branch
							(patterns
								(pattern (degenerate false)
									(p-applied-tag)))
							(value
								(e-call
									(e-lookup-external
										(builtin))
									(e-lookup-local
										(p-assign (ident "children")))
									(e-empty_list)
									(e-lambda
										(args
											(p-assign (ident "acc"))
											(p-assign (ident "c")))
										(e-call
											(e-lookup-external
												(builtin))
											(e-lookup-local
												(p-assign (ident "acc")))
											(e-call
												(e-lookup-local
													(p-assign (ident "flatten")))
												(e-lookup-local
													(p-assign (ident "c")))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-apply (name "List") (builtin)
					(ty-lookup (name "I64") (builtin))))))
	(d-let
		(p-assign (ident "my_tree"))
		(e-tag (name "Node")
			(args
				(e-list
					(elems
						(e-tag (name "Node")
							(args
								(e-list
									(elems
										(e-tag (name "Leaf")
											(args
												(e-num (value "1"))))
										(e-tag (name "Leaf")
											(args
												(e-num (value "2"))))))))
						(e-tag (name "Leaf")
							(args
								(e-num (value "3"))))))))
		(annotation
			(ty-lookup (name "Tree") (local))))
	(s-nominal-decl
		(ty-header (name "Tree"))
		(ty-tag-union
			(ty-tag-name (name "Leaf")
				(ty-lookup (name "I64") (builtin)))
			(ty-tag-name (name "Node")
				(ty-apply (name "List") (builtin)
					(ty-lookup (name "Tree") (local))))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "count")))
				(e-lookup-local
					(p-assign (ident "my_tree"))))
			(e-num (value "5"))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "depth")))
				(e-lookup-local
					(p-assign (ident "my_tree"))))
			(e-num (value "2"))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "sum")))
				(e-lookup-local
					(p-assign (ident "my_tree"))))
			(e-num (value "6"))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "max_val")))
				(e-lookup-local
					(p-assign (ident "my_tree"))))
			(e-num (value "3"))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "leaf_count")))
				(e-lookup-local
					(p-assign (ident "my_tree"))))
			(e-num (value "3"))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "contains")))
				(e-lookup-local
					(p-assign (ident "my_tree")))
				(e-num (value "2")))
			(e-tag (name "True"))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "contains")))
				(e-lookup-local
					(p-assign (ident "my_tree")))
				(e-num (value "99")))
			(e-tag (name "False"))))
	(s-expect
		(e-binop (op "eq")
			(e-call
				(e-lookup-local
					(p-assign (ident "flatten")))
				(e-lookup-local
					(p-assign (ident "my_tree"))))
			(e-list
				(elems
					(e-num (value "1"))
					(e-num (value "2"))
					(e-num (value "3")))))))
~~~
# TYPES
~~~clojure
(inferred-types
	(defs
		(patt (type "Tree -> I64"))
		(patt (type "Tree -> I64"))
		(patt (type "Tree -> I64"))
		(patt (type "Tree -> I64"))
		(patt (type "Tree, (I64 -> I64) -> Tree"))
		(patt (type "Tree -> I64"))
		(patt (type "Tree, I64 -> Bool"))
		(patt (type "Tree -> List(I64)"))
		(patt (type "Tree")))
	(type_decls
		(nominal (type "Tree")
			(ty-header (name "Tree"))))
	(expressions
		(expr (type "Tree -> I64"))
		(expr (type "Tree -> I64"))
		(expr (type "Tree -> I64"))
		(expr (type "Tree -> I64"))
		(expr (type "Tree, (I64 -> I64) -> Tree"))
		(expr (type "Tree -> I64"))
		(expr (type "Tree, I64 -> Bool"))
		(expr (type "Tree -> List(I64)"))
		(expr (type "Tree"))))
~~~
