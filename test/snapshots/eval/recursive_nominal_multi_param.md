# META
~~~ini
description=Regression test: multi-parameter recursive function on nominal type should not segfault
type=snippet
~~~
# SOURCE
~~~roc
Tree := [Leaf(I64), Node(List(Tree))]

# Single-parameter recursion works
count : Tree -> I64
count = |t|
	match t {
		Leaf(_) => 1
		Node(children) =>
			List.fold(children, 1, |acc, c| acc + count(c))
	}

# Multi-parameter recursion should also work (crashes with segfault)
count_if : Tree, I64 -> I64
count_if = |t, target|
	match t {
		Leaf(v) => if v == target 1 else 0
		Node(children) =>
			List.fold(children, 0, |acc, c| acc + count_if(c, target))
	}

my_tree : Tree
my_tree = Node([Leaf(1), Leaf(2), Leaf(1)])

single_result : I64
single_result = count(my_tree)

multi_result : I64
multi_result = count_if(my_tree, 1)

expect single_result == 4
expect multi_result == 2
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
LowerIdent,OpColon,UpperIdent,Comma,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,Comma,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,KwIf,LowerIdent,OpEquals,LowerIdent,Int,KwElse,Int,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,LowerIdent,OpPlus,LowerIdent,NoSpaceOpenRound,LowerIdent,Comma,LowerIdent,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,
LowerIdent,OpAssign,UpperIdent,NoSpaceOpenRound,OpenSquare,UpperIdent,NoSpaceOpenRound,Int,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,Int,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,Int,CloseRound,CloseSquare,CloseRound,
LowerIdent,OpColon,UpperIdent,
LowerIdent,OpAssign,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,
LowerIdent,OpColon,UpperIdent,
LowerIdent,OpAssign,LowerIdent,NoSpaceOpenRound,LowerIdent,Comma,Int,CloseRound,
KwExpect,LowerIdent,OpEquals,Int,
KwExpect,LowerIdent,OpEquals,Int,
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
		(s-type-anno (name "count_if")
			(ty-fn
				(ty (name "Tree"))
				(ty (name "I64"))
				(ty (name "I64"))))
		(s-decl
			(p-ident (raw "count_if"))
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
							(e-if-then-else
								(e-binop (op "==")
									(e-ident (raw "v"))
									(e-ident (raw "target")))
								(e-int (raw "1"))
								(e-int (raw "0"))))
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
											(e-ident (raw "count_if"))
											(e-ident (raw "c"))
											(e-ident (raw "target")))))))))))
		(s-type-anno (name "my_tree")
			(ty (name "Tree")))
		(s-decl
			(p-ident (raw "my_tree"))
			(e-apply
				(e-tag (raw "Node"))
				(e-list
					(e-apply
						(e-tag (raw "Leaf"))
						(e-int (raw "1")))
					(e-apply
						(e-tag (raw "Leaf"))
						(e-int (raw "2")))
					(e-apply
						(e-tag (raw "Leaf"))
						(e-int (raw "1"))))))
		(s-type-anno (name "single_result")
			(ty (name "I64")))
		(s-decl
			(p-ident (raw "single_result"))
			(e-apply
				(e-ident (raw "count"))
				(e-ident (raw "my_tree"))))
		(s-type-anno (name "multi_result")
			(ty (name "I64")))
		(s-decl
			(p-ident (raw "multi_result"))
			(e-apply
				(e-ident (raw "count_if"))
				(e-ident (raw "my_tree"))
				(e-int (raw "1"))))
		(s-expect
			(e-binop (op "==")
				(e-ident (raw "single_result"))
				(e-int (raw "4"))))
		(s-expect
			(e-binop (op "==")
				(e-ident (raw "multi_result"))
				(e-int (raw "2"))))))
~~~
# FORMATTED
~~~roc
Tree := [Leaf(I64), Node(List(Tree))]

# Single-parameter recursion works
count : Tree -> I64
count = |t|
	match t {
		Leaf(_) => 1
		Node(children) =>
			List.fold(children, 1, |acc, c| acc + count(c))
		}

# Multi-parameter recursion should also work (crashes with segfault)
count_if : Tree, I64 -> I64
count_if = |t, target|
	match t {
		Leaf(v) => if v == target 1 else 0
		Node(children) =>
			List.fold(children, 0, |acc, c| acc + count_if(c, target))
		}

my_tree : Tree
my_tree = Node([Leaf(1), Leaf(2), Leaf(1)])

single_result : I64
single_result = count(my_tree)

multi_result : I64
multi_result = count_if(my_tree, 1)

expect single_result == 4
expect multi_result == 2
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
		(p-assign (ident "count_if"))
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
								(e-if
									(if-branches
										(if-branch
											(e-binop (op "eq")
												(e-lookup-local
													(p-assign (ident "v")))
												(e-lookup-local
													(p-assign (ident "target"))))
											(e-num (value "1"))))
									(if-else
										(e-num (value "0"))))))
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
									(e-closure
										(captures
											(capture (ident "target")))
										(e-lambda
											(args
												(p-assign (ident "acc"))
												(p-assign (ident "c")))
											(e-binop (op "add")
												(e-lookup-local
													(p-assign (ident "acc")))
												(e-call
													(e-lookup-local
														(p-assign (ident "count_if")))
													(e-lookup-local
														(p-assign (ident "c")))
													(e-lookup-local
														(p-assign (ident "target"))))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin))
				(ty-lookup (name "I64") (builtin)))))
	(d-let
		(p-assign (ident "my_tree"))
		(e-tag (name "Node")
			(args
				(e-list
					(elems
						(e-tag (name "Leaf")
							(args
								(e-num (value "1"))))
						(e-tag (name "Leaf")
							(args
								(e-num (value "2"))))
						(e-tag (name "Leaf")
							(args
								(e-num (value "1"))))))))
		(annotation
			(ty-lookup (name "Tree") (local))))
	(d-let
		(p-assign (ident "single_result"))
		(e-call
			(e-lookup-local
				(p-assign (ident "count")))
			(e-lookup-local
				(p-assign (ident "my_tree"))))
		(annotation
			(ty-lookup (name "I64") (builtin))))
	(d-let
		(p-assign (ident "multi_result"))
		(e-call
			(e-lookup-local
				(p-assign (ident "count_if")))
			(e-lookup-local
				(p-assign (ident "my_tree")))
			(e-num (value "1")))
		(annotation
			(ty-lookup (name "I64") (builtin))))
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
			(e-lookup-local
				(p-assign (ident "single_result")))
			(e-num (value "4"))))
	(s-expect
		(e-binop (op "eq")
			(e-lookup-local
				(p-assign (ident "multi_result")))
			(e-num (value "2")))))
~~~
# TYPES
~~~clojure
(inferred-types
	(defs
		(patt (type "Tree -> I64"))
		(patt (type "Tree, I64 -> I64"))
		(patt (type "Tree"))
		(patt (type "I64"))
		(patt (type "I64")))
	(type_decls
		(nominal (type "Tree")
			(ty-header (name "Tree"))))
	(expressions
		(expr (type "Tree -> I64"))
		(expr (type "Tree, I64 -> I64"))
		(expr (type "Tree"))
		(expr (type "I64"))
		(expr (type "I64"))))
~~~
