///|
/// Type identifier with optional namespace.
pub(all) struct TypeIdent {
  ns : String? // e.g., "auth" in auth.SentCode
  name : String // e.g., "SentCode" or "User"
} derive(Show, Eq)

///|
/// Creates a new TypeIdent with optional namespace.
pub fn TypeIdent::new(name~ : String, ns? : String) -> TypeIdent {
  { ns, name }
}

///|
/// Creates a simple TypeIdent without namespace.
pub fn TypeIdent::simple(name : String) -> TypeIdent {
  { ns: None, name }
}

///|
/// Creates a TypeIdent with a namespace.
pub fn TypeIdent::namespaced(ns : String, name : String) -> TypeIdent {
  { ns: Some(ns), name }
}

///|
/// Term in TL expressions (type-term/nat-term).
pub(all) enum Term {
  Paren(Expr) // (expr)
  Ident(TypeIdent) // type-ident (including "#")
  Var(String) // var-ident
  NatConst(Int) // nat-const
  Percent(Term) // % term
  Apply(TypeIdent, Array[Expr]) // type-ident<expr, ...>
} derive(Show, Eq)

///|
/// Subexpression with optional nat-const addition.
pub(all) enum Subexpr {
  Term(Term)
  AddLeft(Int, Subexpr) // nat-const + subexpr
  AddRight(Subexpr, Int) // subexpr + nat-const
} derive(Show, Eq)

///|
/// Expression: sequence of subexpressions (application by juxtaposition).
pub(all) struct Expr {
  items : Array[Subexpr]
} derive(Show, Eq)

///|
/// Creates a new expression from subexpressions.
pub fn Expr::new(items~ : Array[Subexpr]) -> Expr {
  { items, }
}
