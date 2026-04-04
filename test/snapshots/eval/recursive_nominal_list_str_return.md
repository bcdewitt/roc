# META
~~~ini
description=Regression test: recursive nominal type function returning List(Str) should not crash
type=snippet
~~~
# SOURCE
~~~roc
Tree := [Leaf(Str), Branch(List(Tree))]

# Returning List(Str) from recursive function on nominal type
collect_labels : Tree -> List(Str)
collect_labels = |t|
	match t {
		Leaf(s) => [s]
		Branch(children) =>
			List.fold(children, [], |acc, c| List.concat(acc, collect_labels(c)))
	}

my_tree : Tree
my_tree = Branch([Leaf("hello"), Leaf("world")])

labels : List(Str)
labels = collect_labels(my_tree)

expect labels == ["hello", "world"]
~~~
# EXPECTED
NIL
# PROBLEMS
NIL
# TOKENS
~~~zig
UpperIdent,OpColonEqual,OpenSquare,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,CloseRound,CloseSquare,
LowerIdent,OpColon,UpperIdent,OpArrow,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,
LowerIdent,OpAssign,OpBar,LowerIdent,OpBar,
KwMatch,LowerIdent,OpenCurly,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,OpenSquare,LowerIdent,CloseSquare,
UpperIdent,NoSpaceOpenRound,LowerIdent,CloseRound,OpFatArrow,
UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,OpenSquare,CloseSquare,Comma,OpBar,LowerIdent,Comma,LowerIdent,OpBar,UpperIdent,NoSpaceDotLowerIdent,NoSpaceOpenRound,LowerIdent,Comma,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,CloseRound,CloseRound,
CloseCurly,
LowerIdent,OpColon,UpperIdent,
LowerIdent,OpAssign,UpperIdent,NoSpaceOpenRound,OpenSquare,UpperIdent,NoSpaceOpenRound,StringStart,StringPart,StringEnd,CloseRound,Comma,UpperIdent,NoSpaceOpenRound,StringStart,StringPart,StringEnd,CloseRound,CloseSquare,CloseRound,
LowerIdent,OpColon,UpperIdent,NoSpaceOpenRound,UpperIdent,CloseRound,
LowerIdent,OpAssign,LowerIdent,NoSpaceOpenRound,LowerIdent,CloseRound,
KwExpect,LowerIdent,OpEquals,OpenSquare,StringStart,StringPart,StringEnd,Comma,StringStart,StringPart,StringEnd,CloseSquare,
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
						(ty (name "Str")))
					(ty-apply
						(ty (name "Branch"))
						(ty-apply
							(ty (name "List"))
							(ty (name "Tree")))))))
		(s-type-anno (name "collect_labels")
			(ty-fn
				(ty (name "Tree"))
				(ty-apply
					(ty (name "List"))
					(ty (name "Str")))))
		(s-decl
			(p-ident (raw "collect_labels"))
			(e-lambda
				(args
					(p-ident (raw "t")))
				(e-match
					(e-ident (raw "t"))
					(branches
						(branch
							(p-tag (raw "Leaf")
								(p-ident (raw "s")))
							(e-list
								(e-ident (raw "s"))))
						(branch
							(p-tag (raw "Branch")
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
											(e-ident (raw "collect_labels"))
											(e-ident (raw "c")))))))))))
		(s-type-anno (name "my_tree")
			(ty (name "Tree")))
		(s-decl
			(p-ident (raw "my_tree"))
			(e-apply
				(e-tag (raw "Branch"))
				(e-list
					(e-apply
						(e-tag (raw "Leaf"))
						(e-string
							(e-string-part (raw "hello"))))
					(e-apply
						(e-tag (raw "Leaf"))
						(e-string
							(e-string-part (raw "world")))))))
		(s-type-anno (name "labels")
			(ty-apply
				(ty (name "List"))
				(ty (name "Str"))))
		(s-decl
			(p-ident (raw "labels"))
			(e-apply
				(e-ident (raw "collect_labels"))
				(e-ident (raw "my_tree"))))
		(s-expect
			(e-binop (op "==")
				(e-ident (raw "labels"))
				(e-list
					(e-string
						(e-string-part (raw "hello")))
					(e-string
						(e-string-part (raw "world"))))))))
~~~
# FORMATTED
~~~roc
Tree := [Leaf(Str), Branch(List(Tree))]

# Returning List(Str) from recursive function on nominal type
collect_labels : Tree -> List(Str)
collect_labels = |t|
	match t {
		Leaf(s) => [s]
		Branch(children) =>
			List.fold(children, [], |acc, c| List.concat(acc, collect_labels(c)))
		}

my_tree : Tree
my_tree = Branch([Leaf("hello"), Leaf("world")])

labels : List(Str)
labels = collect_labels(my_tree)

expect labels == ["hello", "world"]
~~~
# CANONICALIZE
~~~clojure
(can-ir
	(d-let
		(p-assign (ident "collect_labels"))
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
											(p-assign (ident "s")))))))
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
													(p-assign (ident "collect_labels")))
												(e-lookup-local
													(p-assign (ident "c")))))))))))))
		(annotation
			(ty-fn (effectful false)
				(ty-lookup (name "Tree") (local))
				(ty-apply (name "List") (builtin)
					(ty-lookup (name "Str") (builtin))))))
	(d-let
		(p-assign (ident "my_tree"))
		(e-tag (name "Branch")
			(args
				(e-list
					(elems
						(e-tag (name "Leaf")
							(args
								(e-string
									(e-literal (string "hello")))))
						(e-tag (name "Leaf")
							(args
								(e-string
									(e-literal (string "world")))))))))
		(annotation
			(ty-lookup (name "Tree") (local))))
	(d-let
		(p-assign (ident "labels"))
		(e-call
			(e-lookup-local
				(p-assign (ident "collect_labels")))
			(e-lookup-local
				(p-assign (ident "my_tree"))))
		(annotation
			(ty-apply (name "List") (builtin)
				(ty-lookup (name "Str") (builtin)))))
	(s-nominal-decl
		(ty-header (name "Tree"))
		(ty-tag-union
			(ty-tag-name (name "Leaf")
				(ty-lookup (name "Str") (builtin)))
			(ty-tag-name (name "Branch")
				(ty-apply (name "List") (builtin)
					(ty-lookup (name "Tree") (local))))))
	(s-expect
		(e-binop (op "eq")
			(e-lookup-local
				(p-assign (ident "labels")))
			(e-list
				(elems
					(e-string
						(e-literal (string "hello")))
					(e-string
						(e-literal (string "world"))))))))
~~~
# TYPES
~~~clojure
(inferred-types
	(defs
		(patt (type "Tree -> List(Str)"))
		(patt (type "Tree"))
		(patt (type "List(Str)")))
	(type_decls
		(nominal (type "Tree")
			(ty-header (name "Tree"))))
	(expressions
		(expr (type "Tree -> List(Str)"))
		(expr (type "Tree"))
		(expr (type "List(Str)"))))
~~~
