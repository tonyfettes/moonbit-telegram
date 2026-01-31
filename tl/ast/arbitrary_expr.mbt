///|
/// Arbitrary trait implementations for expression types

// Helper functions

fn abs_int(n : Int) -> Int {
  if n < 0 {
    -n
  } else {
    n
  }
}

///|
fn subexpr_starts_with_nat_const(expr : Subexpr) -> Bool {
  match expr {
    Subexpr::Term(Term::NatConst(_)) => true
    Subexpr::Term(_) => false
    Subexpr::AddLeft(_, _) => true
    Subexpr::AddRight(left, _) => subexpr_starts_with_nat_const(left)
  }
}

///|
fn wrap_add_right_left(expr : Subexpr) -> Subexpr {
  if subexpr_starts_with_nat_const(expr) {
    Subexpr::Term(Term::Paren(Expr::new(items=[expr])))
  } else {
    expr
  }
}

// Arbitrary implementations

///|
/// Generates a TypeIdent with optional namespace
pub impl @quickcheck.Arbitrary for TypeIdent with arbitrary(size, rs) {
  let ns : LowerIdent? = @quickcheck.Arbitrary::arbitrary(size, rs)
  let name : UpperIdent = @quickcheck.Arbitrary::arbitrary(size, rs)
  TypeIdent::new(name~, ns?)
}

///|
/// Generates a Term (sized, recursive)
pub impl @quickcheck.Arbitrary for Term with arbitrary(size, rs) {
  if size <= 0 {
    let choice_gen = @qc.frequency([
      (3, gen_lower_ident().fmap(fn(s) { Term::Var(s) })),
      (2, gen_term_type_ident().fmap(fn(i) { Term::Ident(i) })),
      (2, @qc.small_int().fmap(fn(n) { Term::NatConst(abs_int(n)) })),
      (1, @qc.pure(Term::Ident(TypeIdent::simple(UpperIdent::new(value="#"))))),
    ])
    choice_gen.run(size, rs)
  } else {
    let smaller = size / 2
    let choice_gen = @qc.frequency([
      (3, gen_lower_ident().fmap(fn(s) { Term::Var(s) })),
      (2, gen_term_type_ident().fmap(fn(i) { Term::Ident(i) })),
      (2, @qc.small_int().fmap(fn(n) { Term::NatConst(abs_int(n)) })),
      (1, gen_term_sized(smaller).fmap(fn(t) { Term::Percent(t) })),
      (1, gen_expr_sized(smaller).fmap(fn(e) { Term::Paren(e) })),
      (
        1,
        @qc.liftA2(
          fn(i, params) { Term::Apply(i, params) },
          gen_simple_type_ident(),
          gen_expr_array(smaller),
        ),
      ),
    ])
    choice_gen.run(size, rs)
  }
}

///|
/// Generates a Subexpr (sized, recursive)
pub impl @quickcheck.Arbitrary for Subexpr with arbitrary(size, rs) {
  if size <= 0 {
    let term : Term = @quickcheck.Arbitrary::arbitrary(size, rs)
    Subexpr::Term(term)
  } else {
    let smaller = size / 2
    let choice_gen = @qc.frequency([
      (5, gen_term().fmap(fn(t) { Subexpr::Term(t) })),
      (
        1,
        @qc.liftA2(
          fn(n, right) { Subexpr::AddLeft(abs_int(n), right) },
          @qc.small_int(),
          gen_subexpr_sized(smaller),
        ),
      ),
      (
        1,
        @qc.liftA2(
          fn(left, n) {
            Subexpr::AddRight(wrap_add_right_left(left), abs_int(n))
          },
          gen_subexpr_sized(smaller),
          @qc.small_int(),
        ),
      ),
    ])
    choice_gen.run(size, rs)
  }
}

///|
/// Generates an Expr (array of subexpressions)
pub impl @quickcheck.Arbitrary for Expr with arbitrary(size, rs) {
  let smaller = if size <= 0 { 0 } else { size / 2 }
  let len_gen = @qc.int_range(1, 3)
  let len = len_gen.run(size, rs)
  let subexpr_gen = gen_subexpr_sized(smaller)
  let items = Array::makei(len, fn(_) { subexpr_gen.run(size, rs) })
  Expr::new(items~)
}

// Private helper generators (will be removed in Phase 9)

///|
fn gen_lower_ident() -> @qc.Gen[LowerIdent] {
  @qc.Gen::new(fn(size, rs) {
    let ident : LowerIdent = @quickcheck.Arbitrary::arbitrary(size, rs)
    ident
  })
}

///|
fn gen_upper_ident() -> @qc.Gen[UpperIdent] {
  @qc.Gen::new(fn(size, rs) {
    let ident : UpperIdent = @quickcheck.Arbitrary::arbitrary(size, rs)
    ident
  })
}

///|
fn gen_term_type_ident() -> @qc.Gen[TypeIdent] {
  gen_namespace().bind(fn(ns) {
    gen_upper_ident().fmap(fn(name) {
      match ns {
        None => TypeIdent::simple(name)
        Some(ns_name) => TypeIdent::new(name~, ns=ns_name)
      }
    })
  })
}

///|
fn gen_namespace() -> @qc.Gen[LowerIdent?] {
  @qc.frequency([
    (3, @qc.pure(None)),
    (1, gen_lower_ident().fmap(fn(x) { Some(x) })),
  ])
}

///|
fn gen_simple_type_ident() -> @qc.Gen[TypeIdent] {
  gen_upper_ident().fmap(fn(name) { TypeIdent::simple(name) })
}

///|
fn gen_term() -> @qc.Gen[Term] {
  @qc.Gen::new(fn(size, rs) {
    let term : Term = @quickcheck.Arbitrary::arbitrary(size, rs)
    term
  })
}

///|
fn gen_term_sized(size : Int) -> @qc.Gen[Term] {
  if size <= 0 {
    @qc.frequency([
      (3, gen_lower_ident().fmap(fn(s) { Term::Var(s) })),
      (2, gen_term_type_ident().fmap(fn(i) { Term::Ident(i) })),
      (2, @qc.small_int().fmap(fn(n) { Term::NatConst(abs_int(n)) })),
      (1, @qc.pure(Term::Ident(TypeIdent::simple(UpperIdent::new(value="#"))))),
    ])
  } else {
    let smaller = size / 2
    @qc.frequency([
      (3, gen_lower_ident().fmap(fn(s) { Term::Var(s) })),
      (2, gen_term_type_ident().fmap(fn(i) { Term::Ident(i) })),
      (2, @qc.small_int().fmap(fn(n) { Term::NatConst(abs_int(n)) })),
      (1, gen_term_sized(smaller).fmap(fn(t) { Term::Percent(t) })),
      (1, gen_expr_sized(smaller).fmap(fn(e) { Term::Paren(e) })),
      (
        1,
        @qc.liftA2(
          fn(i, params) { Term::Apply(i, params) },
          gen_simple_type_ident(),
          gen_expr_array(smaller),
        ),
      ),
    ])
  }
}

///|
fn gen_subexpr_sized(size : Int) -> @qc.Gen[Subexpr] {
  if size <= 0 {
    gen_term().fmap(fn(t) { Subexpr::Term(t) })
  } else {
    let smaller = size / 2
    @qc.frequency([
      (5, gen_term().fmap(fn(t) { Subexpr::Term(t) })),
      (
        1,
        @qc.liftA2(
          fn(n, right) { Subexpr::AddLeft(abs_int(n), right) },
          @qc.small_int(),
          gen_subexpr_sized(smaller),
        ),
      ),
      (
        1,
        @qc.liftA2(
          fn(left, n) {
            Subexpr::AddRight(wrap_add_right_left(left), abs_int(n))
          },
          gen_subexpr_sized(smaller),
          @qc.small_int(),
        ),
      ),
    ])
  }
}

///|
fn gen_expr_sized(size : Int) -> @qc.Gen[Expr] {
  let smaller = if size <= 0 { 0 } else { size / 2 }
  @qc.int_range(1, 3).bind(fn(len) {
    let gen = gen_subexpr_sized(smaller)
    @qc.Gen::new(fn(s, rs) {
      let items = Array::makei(len, fn(_) { gen.run(s, rs) })
      Expr::new(items~)
    })
  })
}

///|
fn gen_expr_array(size : Int) -> @qc.Gen[Array[Expr]] {
  @qc.int_range(1, 3).bind(fn(len) {
    let gen = gen_expr_sized(size / 2)
    @qc.Gen::new(fn(s, rs) { Array::makei(len, fn(_) { gen.run(s, rs) }) })
  })
}
