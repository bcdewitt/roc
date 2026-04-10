# META
~~~ini
description=Regression test: nominal type with multi-payload recursive tag (binary tree) should not segfault
type=snippet
~~~
# SOURCE
~~~roc
Tree := [Leaf(I64), Node(Tree, Tree)]

count : Tree -> I64
count = |t|
	match t {
		Leaf(_) => 1
		Node(l, r) => 1 + count(l) + count(r)
	}

my_tree : Tree
my_tree = Node(Leaf(1), Leaf(2))

result : I64
result = count(my_tree)

expect result == 3
~~~
# EXPECTED
NIL
# PROBLEMS
NIL
# TOKENS
~~~zig
UpperIdent,OpColonEqual,OpenSquare,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,UpperIdent,Comma,UpperIdent,CloseRound,CloseSquare,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,Underscore,CloseRound,OpFatArrow,Int,
UpperIdent,NoSpaceOpenRound,LowerIdent,Comma,LowerIdent,CloseRound,OpFatArrow,Int,OpPlus,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpPlus,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,
LowerIdent,OpAssign,UpperIdent,NoSpaceOpenRound,UpperIdent,NoSpaceOpenRound,Int,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,Int,CloseRound,CloseRound,
LowerIdent,OpColon,UpperIdent,
LowerIdent,OpAssign,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,
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
						(ty (name "Tree"))
						(ty (name "Tree"))))))
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
								(p-ident (raw "l"))
								(p-ident (raw "r")))
							(e-binop (op "+")
								(e-binop (op "+")
									(e-int (raw "1"))
									(e-apply
										(e-ident (raw "count"))
										(e-ident (raw "l"))))
								(e-apply
									(e-ident (raw "count"))
									(e-ident (raw "r")))))))))
		(s-type-anno (name "my_tree")
			(ty (name "Tree")))
		(s-decl
			(p-ident (raw "my_tree"))
			(e-apply
				(e-tag (raw "Node"))
				(e-apply
					(e-tag (raw "Leaf"))
					(e-int (raw "1")))
				(e-apply
					(e-tag (raw "Leaf"))
					(e-int (raw "2")))))
		(s-type-anno (name "result")
			(ty (name "I64")))
		(s-decl
			(p-ident (raw "result"))
			(e-apply
				(e-ident (raw "count"))
				(e-ident (raw "my_tree"))))
		(s-expect
			(e-binop (op "==")
				(e-ident (raw "result"))
				(e-int (raw "3"))))))
~~~
# FORMATTED
~~~roc
NO CHANGE
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
								(e-binop (op "add")
									(e-binop (op "add")
										(e-num (value "1"))
										(e-call
											(e-lookup-local
												(p-assign (ident "count")))
											(e-lookup-local
												(p-assign (ident "l")))))
									(e-call
										(e-lookup-local
											(p-assign (ident "count")))
										(e-lookup-local
											(p-assign (ident "r")))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "I64") (builtin)))))
	(d-let
		(p-assign (ident "my_tree"))
		(e-tag (name "Node")
			(args
				(e-tag (name "Leaf")
					(args
						(e-num (value "1"))))
				(e-tag (name "Leaf")
					(args
						(e-num (value "2"))))))
		(annotation
			(ty-lookup (name "Tree") (local))))
	(d-let
		(p-assign (ident "result"))
		(e-call
			(e-lookup-local
				(p-assign (ident "count")))
			(e-lookup-local
				(p-assign (ident "my_tree"))))
		(annotation
			(ty-lookup (name "I64") (builtin))))
	(s-nominal-decl
		(ty-header (name "Tree"))
		(ty-tag-union
			(ty-tag-name (name "Leaf")
				(ty-lookup (name "I64") (builtin)))
			(ty-tag-name (name "Node")
				(ty-lookup (name "Tree") (local))
				(ty-lookup (name "Tree") (local)))))
	(s-expect
		(e-binop (op "eq")
			(e-lookup-local
				(p-assign (ident "result")))
			(e-num (value "3")))))
~~~
# TYPES
~~~clojure
(inferred-types
	(defs
		(patt (type "Tree -> I64"))
		(patt (type "Tree"))
		(patt (type "I64")))
	(type_decls
		(nominal (type "Tree")
			(ty-header (name "Tree"))))
	(expressions
		(expr (type "Tree -> I64"))
		(expr (type "Tree"))
		(expr (type "I64"))))
~~~
