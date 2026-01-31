///| Arbitrary trait implementations for combinator and schema types

// Helper functions

///|
/// Creates a dummy span (all zeros) for generated AST nodes
fn dummy_span() -> Span {
  let pos = Position::new(line=0, column=0, offset=0)
  Span::new(start=pos, end=pos)
}

// Arbitrary implementations

///|
/// Generates a ResultType
pub impl @quickcheck.Arbitrary for ResultType with arbitrary(size, rs) {
  let gen = @qc.liftA2(
    fn(type_ident, params) { { type_ident, params } },
    gen_type_ident_comb(),
    gen_subexpr_array(),
  )
  gen.run(size, rs)
}

///|
/// Generates a Combinator (sized, recursive through args)
pub impl @quickcheck.Arbitrary for Combinator with arbitrary(size, rs) {
  let smaller = if size <= 0 { 0 } else { size / 2 }
  let gen = @qc.liftA6(
    fn(ns, name, id, opt_args, args, result) {
      { ns, name, id, opt_args, args, result, span: dummy_span() }
    },
    gen_namespace_comb(),
    gen_lower_ident_comb(),
    gen_optional_uint(),
    gen_optional_args_array(),
    gen_args_array(smaller),
    gen_result_type_comb(),
  )
  gen.run(size, rs)
}

///|
/// Generates a FinalDeclData
pub impl @quickcheck.Arbitrary for FinalDeclData with arbitrary(size, rs) {
  let gen = gen_type_ident_comb().fmap(fn(type_ident) {
    { type_ident, span: dummy_span() }
  })
  gen.run(size, rs)
}

///|
/// Generates a FinalDecl
pub impl @quickcheck.Arbitrary for FinalDecl with arbitrary(size, rs) {
  let gen = @qc.frequency([
    (1, gen_final_decl_data().fmap(fn(x) { FinalDecl::New(x) })),
    (1, gen_final_decl_data().fmap(fn(x) { FinalDecl::Final(x) })),
    (1, gen_final_decl_data().fmap(fn(x) { FinalDecl::Empty(x) })),
  ])
  gen.run(size, rs)
}

///|
/// Generates a Declaration (sized, recursive)
pub impl @quickcheck.Arbitrary for Declaration with arbitrary(size, rs) {
  let gen = @qc.frequency([
    (5, gen_combinator().fmap(fn(x) { Declaration::Combinator(x) })),
    (1, gen_final_decl().fmap(fn(x) { Declaration::Final(x) })),
  ])
  gen.run(size, rs)
}

///|
/// Generates a Schema (array of declarations and combinators)
pub impl @quickcheck.Arbitrary for Schema with arbitrary(size, rs) {
  let smaller = if size <= 0 { 0 } else { size / 2 }
  let gen = @qc.liftA2(
    fn(types, functions) { { types, functions, comments: [] } },
    gen_declaration_array(smaller),
    gen_combinator_array(smaller),
  )
  gen.run(size, rs)
}

// Private helper generators (will be removed in Phase 9)

///|
fn gen_lower_ident_comb() -> @qc.Gen[LowerIdent] {
  @qc.Gen::new(fn(size, rs) {
    let ident : LowerIdent = @quickcheck.Arbitrary::arbitrary(size, rs)
    ident
  })
}

///|
fn gen_type_ident_comb() -> @qc.Gen[TypeIdent] {
  @qc.Gen::new(fn(size, rs) {
    let ident : TypeIdent = @quickcheck.Arbitrary::arbitrary(size, rs)
    ident
  })
}

///|
fn gen_subexpr_comb() -> @qc.Gen[Subexpr] {
  @qc.Gen::new(fn(size, rs) {
    let subexpr : Subexpr = @quickcheck.Arbitrary::arbitrary(size, rs)
    subexpr
  })
}

///|
fn gen_namespace_comb() -> @qc.Gen[LowerIdent?] {
  @qc.frequency([
    (3, @qc.pure(None)),
    (1, gen_lower_ident_comb().fmap(fn(x) { Some(x) })),
  ])
}

///|
fn gen_subexpr_array() -> @qc.Gen[Array[Subexpr]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(size, rs) {
        Array::makei(len, fn(_) { gen_subexpr_comb().run(size, rs) })
      })
    }
  })
}

///|
fn gen_optional_args_array() -> @qc.Gen[Array[OptionalArg]] {
  @qc.int_bound(3).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(size, rs) {
        Array::makei(len, fn(_) {
          let arg : OptionalArg = @quickcheck.Arbitrary::arbitrary(size, rs)
          arg
        })
      })
    }
  })
}

///|
fn gen_args_array(size : Int) -> @qc.Gen[Array[Arg]] {
  @qc.int_bound(4).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(_s, rs) {
        Array::makei(len, fn(_) {
          let arg : Arg = @quickcheck.Arbitrary::arbitrary(size, rs)
          arg
        })
      })
    }
  })
}

///|
fn gen_optional_uint() -> @qc.Gen[ConstructorId?] {
  @qc.frequency([
    (2, @qc.pure(None)),
    (
      1,
      @qc.nat().fmap(fn(n) {
        Some(ConstructorId::new(value=n.reinterpret_as_uint()))
      }),
    ),
  ])
}

///|
fn gen_result_type_comb() -> @qc.Gen[ResultType] {
  @qc.Gen::new(fn(size, rs) {
    let result : ResultType = @quickcheck.Arbitrary::arbitrary(size, rs)
    result
  })
}

///|
fn gen_final_decl_data() -> @qc.Gen[FinalDeclData] {
  @qc.Gen::new(fn(size, rs) {
    let data : FinalDeclData = @quickcheck.Arbitrary::arbitrary(size, rs)
    data
  })
}

///|
fn gen_final_decl() -> @qc.Gen[FinalDecl] {
  @qc.Gen::new(fn(size, rs) {
    let decl : FinalDecl = @quickcheck.Arbitrary::arbitrary(size, rs)
    decl
  })
}

///|
fn gen_combinator() -> @qc.Gen[Combinator] {
  @qc.Gen::new(fn(size, rs) {
    let combinator : Combinator = @quickcheck.Arbitrary::arbitrary(size, rs)
    combinator
  })
}

///|
fn gen_declaration_array(size : Int) -> @qc.Gen[Array[Declaration]] {
  @qc.int_bound(4).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(_s, rs) {
        Array::makei(len, fn(_) {
          let decl : Declaration = @quickcheck.Arbitrary::arbitrary(size, rs)
          decl
        })
      })
    }
  })
}

///|
fn gen_combinator_array(size : Int) -> @qc.Gen[Array[Combinator]] {
  @qc.int_bound(4).bind(fn(len) {
    if len == 0 {
      @qc.pure([])
    } else {
      @qc.Gen::new(fn(_s, rs) {
        Array::makei(len, fn(_) {
          let combinator : Combinator = @quickcheck.Arbitrary::arbitrary(
            size, rs,
          )
          combinator
        })
      })
    }
  })
}
