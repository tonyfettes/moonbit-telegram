///| Arbitrary trait implementations for argument types

// Helper functions

///|
/// Generates a boolean (frequently false, rarely true)
fn gen_bool() -> @qc.Gen[Bool] {
  @qc.frequency([(3, @qc.pure(false)), (1, @qc.pure(true))])
}

///|
/// Generates an optional bit index (None or Some(0-31))
fn gen_optional_bit_index() -> @qc.Gen[Int?] {
  @qc.frequency([
    (1, @qc.pure(None)),
    (2, @qc.int_bound(32).fmap(fn(x) { Some(x) })),
  ])
}

// Arbitrary implementations

///|
/// Generates a Conditional
pub impl @quickcheck.Arbitrary for Conditional with arbitrary(size, rs) {
  let cond_gen = @qc.liftA2(
    fn(var_name, bit_index) { { var_name, bit_index } },
    gen_lower_ident_arg(),
    gen_optional_bit_index(),
  )
  cond_gen.run(size, rs)
}

///|
/// Generates a NamedArg
pub impl @quickcheck.Arbitrary for NamedArg with arbitrary(size, rs) {
  let gen = @qc.liftA4(
    fn(name, conditional, bang, type_) { { name, conditional, bang, type_ } },
    gen_lower_ident_arg(),
    gen_conditional(),
    gen_bool(),
    gen_term_arg(),
  )
  gen.run(size, rs)
}

///|
/// Generates an OptionalArg
pub impl @quickcheck.Arbitrary for OptionalArg with arbitrary(size, rs) {
  let gen = @qc.liftA3(
    fn(names, bang, type_) {
      let arg : OptionalArg = { names, bang, type_ }
      arg
    },
    gen_names_array(),
    gen_bool(),
    gen_expr_arg(),
  )
  gen.run(size, rs)
}

///|
/// Generates a GroupedArg
pub impl @quickcheck.Arbitrary for GroupedArg with arbitrary(size, rs) {
  let gen = @qc.liftA3(
    fn(names, bang, type_) {
      let arg : GroupedArg = { names, bang, type_ }
      arg
    },
    gen_names_array(),
    gen_bool(),
    gen_term_arg(),
  )
  gen.run(size, rs)
}

///|
/// Generates an AnonymousArg
pub impl @quickcheck.Arbitrary for AnonymousArg with arbitrary(size, rs) {
  let gen = @qc.liftA2(
    fn(bang, type_) { { bang, type_ } },
    gen_bool(),
    gen_term(),
  )
  gen.run(size, rs)
}

///|
/// Generates a MultiplicityArg (sized, recursive)
pub impl @quickcheck.Arbitrary for MultiplicityArg with arbitrary(size, rs) {
  let smaller = if size <= 0 { 0 } else { size / 2 }
  let gen = @qc.liftA3(
    fn(name, count, args) { { name, count, args } },
    gen_optional_name(),
    gen_term_arg(),
    gen_arg_array(smaller),
  )
  gen.run(size, rs)
}

///|
/// Generates an Arg (sized, recursive union type)
pub impl @quickcheck.Arbitrary for Arg with arbitrary(size, rs) {
  if size <= 0 {
    // Non-recursive variants only
    let choice_gen = @qc.frequency([
      (4, gen_named_arg().fmap(fn(x) { Arg::Named(x) })),
      (2, gen_grouped_arg().fmap(fn(x) { Arg::Grouped(x) })),
      (2, gen_anonymous_arg().fmap(fn(x) { Arg::Anonymous(x) })),
    ])
    choice_gen.run(size, rs)
  } else {
    let smaller = size / 2
    let choice_gen = @qc.frequency([
      (4, gen_named_arg().fmap(fn(x) { Arg::Named(x) })),
      (
        1,
        gen_multiplicity_arg_sized(smaller).fmap(fn(x) { Arg::Multiplicity(x) }),
      ),
      (2, gen_grouped_arg().fmap(fn(x) { Arg::Grouped(x) })),
      (2, gen_anonymous_arg().fmap(fn(x) { Arg::Anonymous(x) })),
    ])
    choice_gen.run(size, rs)
  }
}

// Private helper generators (will be removed in Phase 9)

///|
fn gen_lower_ident_arg() -> @qc.Gen[LowerIdent] {
  @qc.Gen::new(fn(size, rs) {
    let ident : LowerIdent = @quickcheck.Arbitrary::arbitrary(size, rs)
    ident
  })
}

///|
fn gen_conditional() -> @qc.Gen[Conditional?] {
  @qc.frequency([
    (3, @qc.pure(None)),
    (
      1,
      @qc.Gen::new(fn(size, rs) {
        let cond : Conditional = @quickcheck.Arbitrary::arbitrary(size, rs)
        Some(cond)
      }),
    ),
  ])
}

///|
fn gen_term_arg() -> @qc.Gen[Term] {
  @qc.Gen::new(fn(size, rs) {
    let term : Term = @quickcheck.Arbitrary::arbitrary(size, rs)
    term
  })
}

///|
fn gen_expr_arg() -> @qc.Gen[Expr] {
  @qc.Gen::new(fn(size, rs) {
    let expr : Expr = @quickcheck.Arbitrary::arbitrary(size, rs)
    expr
  })
}

///|
fn gen_names_array() -> @qc.Gen[Array[LowerIdent]] {
  @qc.int_range(1, 4).bind(fn(len) {
    @qc.Gen::new(fn(size, rs) {
      Array::makei(len, fn(_) { gen_lower_ident_arg().run(size, rs) })
    })
  })
}

///|
fn gen_optional_name() -> @qc.Gen[LowerIdent?] {
  @qc.frequency([
    (2, @qc.pure(None)),
    (1, gen_lower_ident_arg().fmap(fn(x) { Some(x) })),
  ])
}

///|
fn gen_named_arg() -> @qc.Gen[NamedArg] {
  @qc.Gen::new(fn(size, rs) {
    let arg : NamedArg = @quickcheck.Arbitrary::arbitrary(size, rs)
    arg
  })
}

///|
fn gen_grouped_arg() -> @qc.Gen[GroupedArg] {
  @qc.Gen::new(fn(size, rs) {
    let arg : GroupedArg = @quickcheck.Arbitrary::arbitrary(size, rs)
    arg
  })
}

///|
fn gen_anonymous_arg() -> @qc.Gen[AnonymousArg] {
  @qc.Gen::new(fn(size, rs) {
    let arg : AnonymousArg = @quickcheck.Arbitrary::arbitrary(size, rs)
    arg
  })
}

///|
fn gen_multiplicity_arg_sized(size : Int) -> @qc.Gen[MultiplicityArg] {
  @qc.liftA3(
    fn(name, count, args) { { name, count, args } },
    gen_optional_name(),
    gen_term_arg(),
    gen_arg_array(size),
  )
}

///|
fn gen_arg_array(size : Int) -> @qc.Gen[Array[Arg]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(_s, rs) {
        let gen : @qc.Gen[Arg] = @qc.Gen::new(fn(_sz, r) {
          let arg : Arg = @quickcheck.Arbitrary::arbitrary(size, r)
          arg
        })
        Array::makei(len, fn(_) { gen.run(size, rs) })
      })
    }
  })
}
