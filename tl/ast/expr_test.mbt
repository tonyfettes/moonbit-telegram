///|
test "TypeIdent simple" {
  let ident = TypeIdent::simple("User")
  inspect(ident.name, content="User")
  assert_true(ident.ns is None)
}

///|
test "TypeIdent namespaced" {
  let ident = TypeIdent::namespaced("auth", "SentCode")
  inspect(ident.name, content="SentCode")
  inspect(ident.ns, content="Some(\"auth\")")
}

///|
test "Term Ident" {
  let term = Term::Ident(TypeIdent::simple("User"))
  guard term is Ident(ident) else { fail("expected Ident") }
  inspect(ident.name, content="User")
}

///|
test "Term Apply" {
  let vector = TypeIdent::simple("Vector")
  let arg = Expr::new(items=[Subexpr::Term(Term::Var("t"))])
  let term = Term::Apply(vector, [arg])
  guard term is Apply(ident, params) else { fail("expected Apply") }
  inspect(ident.name, content="Vector")
  inspect(params.length(), content="1")
}

///|
test "Subexpr add" {
  let sub = Subexpr::AddRight(Subexpr::Term(Term::Var("n")), 1)
  guard sub is AddRight(_, 1) else { fail("expected AddRight") }
}

///|
test "Expr sequence" {
  let expr = Expr::new(items=[
    Subexpr::Term(Term::Var("A")),
    Subexpr::Term(Term::Var("B")),
  ])
  inspect(expr.items.length(), content="2")
}
