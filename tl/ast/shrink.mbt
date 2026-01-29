///|
/// Shrink implementation for Position.
/// Shrinks each field independently toward smaller values.
pub impl @qc.Shrink for Position with shrink(self) {
  // Shrink line
  @qc.Shrink::shrink(self.line)
  .map(fn(line) { { ..self, line, } })
  // Shrink column
  .concat(
    @qc.Shrink::shrink(self.column).map(fn(column) { { ..self, column, } }),
  )
  // Shrink offset
  .concat(
    @qc.Shrink::shrink(self.offset).map(fn(offset) { { ..self, offset, } }),
  )
}

///|
/// Shrink implementation for Span.
/// Shrinks start and end positions independently.
pub impl @qc.Shrink for Span with shrink(self) {
  // Shrink start position
  @qc.Shrink::shrink(self.start)
  .map(fn(start) { { ..self, start, } })
  // Shrink end position
  .concat(@qc.Shrink::shrink(self.end).map(fn(end) { { ..self, end, } }))
}

///|
/// Shrink implementation for TypeIdent.
/// Tries removing namespace first, then shrinks the name.
pub impl @qc.Shrink for TypeIdent with shrink(self) {
  // Try removing namespace (simpler case)
  let without_ns = match self.ns {
    Some(_) => Iter::singleton({ ..self, ns: None })
    None => Iter::empty()
  }
  // Shrink namespace if present
  let shrink_ns = @qc.Shrink::shrink(self.ns).map(fn(ns) { { ..self, ns, } })
  // Shrink name
  let shrink_name = @qc.Shrink::shrink(self.name).map(fn(name) {
    { ..self, name, }
  })
  without_ns.concat(shrink_ns).concat(shrink_name)
}

///|
/// Shrink implementation for NatExpr.
/// For recursive variants, first tries simpler base cases, then shrinks components.
pub impl @qc.Shrink for NatExpr with shrink(self) {
  match self {
    Const(n) =>
      // Shrink the integer constant
      @qc.Shrink::shrink(n).map(fn(n) { NatExpr::Const(n) })
    Var(s) =>
      // Shrink the variable name
      @qc.Shrink::shrink(s).map(fn(s) { NatExpr::Var(s) })
    Add(l, r) =>
      // First try the simpler sub-expressions as replacements
      Iter::singleton(l)
      .concat(Iter::singleton(r))
      // Then shrink left operand
      .concat(@qc.Shrink::shrink(l).map(fn(l) { NatExpr::Add(l, r) }))
      // Then shrink right operand
      .concat(@qc.Shrink::shrink(r).map(fn(r) { NatExpr::Add(l, r) }))
    Zero =>
      // Zero is the simplest, no shrinking possible
      Iter::empty()
    Succ(n) =>
      // First try the inner expression as replacement
      Iter::singleton(n)
      // Try Zero as simplest case
      .concat(Iter::singleton(NatExpr::Zero))
      // Then shrink the inner expression
      .concat(@qc.Shrink::shrink(n).map(fn(n) { NatExpr::Succ(n) }))
  }
}

///|
/// Shrink implementation for TypeExpr.
/// For recursive variants, first tries simpler base cases, then shrinks components.
pub impl @qc.Shrink for TypeExpr with shrink(self) {
  match self {
    Ident(i) =>
      // Shrink the type identifier
      @qc.Shrink::shrink(i).map(fn(i) { TypeExpr::Ident(i) })
    Percent(e) =>
      // First try the inner expression as replacement
      Iter::singleton(e)
      // Then shrink the inner expression
      .concat(@qc.Shrink::shrink(e).map(fn(e) { TypeExpr::Percent(e) }))
    Apply(i, params) =>
      // First try just the Ident without params
      Iter::singleton(TypeExpr::Ident(i))
      // Shrink the type identifier
      .concat(@qc.Shrink::shrink(i).map(fn(i) { TypeExpr::Apply(i, params) }))
      // Shrink the params array
      .concat(
        @qc.Shrink::shrink(params).map(fn(params) { TypeExpr::Apply(i, params) }),
      )
    Var(s) =>
      // Shrink the variable name
      @qc.Shrink::shrink(s).map(fn(s) { TypeExpr::Var(s) })
    Nat =>
      // Nat is the simplest type, no shrinking possible
      Iter::empty()
  }
}

///|
/// Shrink implementation for Expr.
/// Shrinks the contained expression.
pub impl @qc.Shrink for Expr with shrink(self) {
  match self {
    Type(t) => @qc.Shrink::shrink(t).map(fn(t) { Expr::Type(t) })
    Nat(n) => @qc.Shrink::shrink(n).map(fn(n) { Expr::Nat(n) })
  }
}

///|
/// Shrink implementation for Conditional.
/// Tries removing bit_index first, then shrinks var_name.
pub impl @qc.Shrink for Conditional with shrink(self) {
  // Try removing bit_index (simpler case)
  let without_bit = match self.bit_index {
    Some(_) => Iter::singleton({ ..self, bit_index: None })
    None => Iter::empty()
  }
  // Shrink var_name
  let shrink_var = @qc.Shrink::shrink(self.var_name).map(fn(var_name) {
    { ..self, var_name, }
  })
  // Shrink bit_index
  let shrink_bit = @qc.Shrink::shrink(self.bit_index).map(fn(bit_index) {
    { ..self, bit_index, }
  })
  without_bit.concat(shrink_var).concat(shrink_bit)
}

///|
/// Shrink implementation for NamedArg.
/// Tries removing conditional first, then shrinks each field.
pub impl @qc.Shrink for NamedArg with shrink(self) {
  // Try removing conditional
  let without_cond = match self.conditional {
    Some(_) => Iter::singleton({ ..self, conditional: None })
    None => Iter::empty()
  }
  // Try setting bang to false
  let without_bang = if self.bang {
    Iter::singleton({ ..self, bang: false })
  } else {
    Iter::empty()
  }
  // Shrink name
  let shrink_name = @qc.Shrink::shrink(self.name).map(fn(name) {
    { ..self, name, }
  })
  // Shrink conditional
  let shrink_cond = @qc.Shrink::shrink(self.conditional).map(fn(conditional) {
    { ..self, conditional, }
  })
  // Shrink type_
  let shrink_type = @qc.Shrink::shrink(self.type_).map(fn(type_) {
    { ..self, type_, }
  })
  without_cond
  .concat(without_bang)
  .concat(shrink_name)
  .concat(shrink_cond)
  .concat(shrink_type)
}

///|
/// Shrink implementation for OptionalArg.
/// Shrinks names array, bang, and type_.
pub impl @qc.Shrink for OptionalArg with shrink(self) {
  // Try setting bang to false
  let without_bang = if self.bang {
    Iter::singleton({ ..self, bang: false })
  } else {
    Iter::empty()
  }
  // Shrink names array
  let shrink_names = @qc.Shrink::shrink(self.names).map(fn(names) {
    { ..self, names, }
  })
  // Shrink type_
  let shrink_type = @qc.Shrink::shrink(self.type_).map(fn(type_) {
    { ..self, type_, }
  })
  without_bang.concat(shrink_names).concat(shrink_type)
}

///|
/// Shrink implementation for MultiplicityArg.
/// Tries removing name, then shrinks count and nested args.
pub impl @qc.Shrink for MultiplicityArg with shrink(self) {
  // Try removing name
  let without_name = match self.name {
    Some(_) => Iter::singleton({ ..self, name: None })
    None => Iter::empty()
  }
  // Shrink name
  let shrink_name = @qc.Shrink::shrink(self.name).map(fn(name) {
    { ..self, name, }
  })
  // Shrink count
  let shrink_count = @qc.Shrink::shrink(self.count).map(fn(count) {
    { ..self, count, }
  })
  // Shrink args array
  let shrink_args = @qc.Shrink::shrink(self.args).map(fn(args) {
    { ..self, args, }
  })
  without_name.concat(shrink_name).concat(shrink_count).concat(shrink_args)
}

///|
/// Shrink implementation for GroupedArg.
/// Shrinks names, bang, and type_.
pub impl @qc.Shrink for GroupedArg with shrink(self) {
  // Try setting bang to false
  let without_bang = if self.bang {
    Iter::singleton({ ..self, bang: false })
  } else {
    Iter::empty()
  }
  // Shrink names array
  let shrink_names = @qc.Shrink::shrink(self.names).map(fn(names) {
    { ..self, names, }
  })
  // Shrink type_
  let shrink_type = @qc.Shrink::shrink(self.type_).map(fn(type_) {
    { ..self, type_, }
  })
  without_bang.concat(shrink_names).concat(shrink_type)
}

///|
/// Shrink implementation for AnonymousArg.
/// Tries removing bang, then shrinks type_.
pub impl @qc.Shrink for AnonymousArg with shrink(self) {
  // Try setting bang to false
  let without_bang = if self.bang {
    Iter::singleton({ ..self, bang: false })
  } else {
    Iter::empty()
  }
  // Shrink type_
  let shrink_type = @qc.Shrink::shrink(self.type_).map(fn(type_) {
    { ..self, type_, }
  })
  without_bang.concat(shrink_type)
}

///|
/// Shrink implementation for Arg.
/// Shrinks the contained argument type.
pub impl @qc.Shrink for Arg with shrink(self) {
  match self {
    Named(a) => @qc.Shrink::shrink(a).map(fn(a) { Arg::Named(a) })
    Multiplicity(a) =>
      // First try converting nested args to simpler Arg types if possible
      @qc.Shrink::shrink(a).map(fn(a) { Arg::Multiplicity(a) })
    Grouped(a) => @qc.Shrink::shrink(a).map(fn(a) { Arg::Grouped(a) })
    Anonymous(a) => @qc.Shrink::shrink(a).map(fn(a) { Arg::Anonymous(a) })
  }
}

///|
/// Shrink implementation for ResultType.
/// Shrinks type_ident and params.
pub impl @qc.Shrink for ResultType with shrink(self) {
  // Shrink type_ident
  @qc.Shrink::shrink(self.type_ident)
  .map(fn(type_ident) { { ..self, type_ident, } })
  // Shrink params array
  .concat(
    @qc.Shrink::shrink(self.params).map(fn(params) { { ..self, params, } }),
  )
}

///|
/// Shrink implementation for FinalDeclData.
/// Shrinks type_ident and span.
pub impl @qc.Shrink for FinalDeclData with shrink(self) {
  // Shrink type_ident
  @qc.Shrink::shrink(self.type_ident)
  .map(fn(type_ident) { { ..self, type_ident, } })
  // Shrink span
  .concat(@qc.Shrink::shrink(self.span).map(fn(span) { { ..self, span, } }))
}

///|
/// Shrink implementation for FinalDecl.
/// Shrinks the contained FinalDeclData.
pub impl @qc.Shrink for FinalDecl with shrink(self) {
  match self {
    New(d) => @qc.Shrink::shrink(d).map(fn(d) { FinalDecl::New(d) })
    Final(d) => @qc.Shrink::shrink(d).map(fn(d) { FinalDecl::Final(d) })
    Empty(d) => @qc.Shrink::shrink(d).map(fn(d) { FinalDecl::Empty(d) })
  }
}

///|
/// Shrink implementation for Combinator.
/// Shrinks each field, prioritizing removing optional fields.
pub impl @qc.Shrink for Combinator with shrink(self) {
  // Try removing namespace
  let without_ns = match self.ns {
    Some(_) => Iter::singleton({ ..self, ns: None })
    None => Iter::empty()
  }
  // Try removing id
  let without_id = match self.id {
    Some(_) => Iter::singleton({ ..self, id: None })
    None => Iter::empty()
  }
  // Try emptying opt_args
  let without_opt_args = if self.opt_args.length() > 0 {
    Iter::singleton({ ..self, opt_args: [] })
  } else {
    Iter::empty()
  }
  // Try emptying args
  let without_args = if self.args.length() > 0 {
    Iter::singleton({ ..self, args: [] })
  } else {
    Iter::empty()
  }
  // Shrink namespace
  let shrink_ns = @qc.Shrink::shrink(self.ns).map(fn(ns) { { ..self, ns, } })
  // Shrink name
  let shrink_name = @qc.Shrink::shrink(self.name).map(fn(name) {
    { ..self, name, }
  })
  // Shrink id
  let shrink_id = @qc.Shrink::shrink(self.id).map(fn(id) { { ..self, id, } })
  // Shrink opt_args
  let shrink_opt_args = @qc.Shrink::shrink(self.opt_args).map(fn(opt_args) {
    { ..self, opt_args, }
  })
  // Shrink args
  let shrink_args = @qc.Shrink::shrink(self.args).map(fn(args) {
    { ..self, args, }
  })
  // Shrink result
  let shrink_result = @qc.Shrink::shrink(self.result).map(fn(result) {
    { ..self, result, }
  })
  // Shrink span
  let shrink_span = @qc.Shrink::shrink(self.span).map(fn(span) {
    { ..self, span, }
  })
  without_ns
  .concat(without_id)
  .concat(without_opt_args)
  .concat(without_args)
  .concat(shrink_ns)
  .concat(shrink_name)
  .concat(shrink_id)
  .concat(shrink_opt_args)
  .concat(shrink_args)
  .concat(shrink_result)
  .concat(shrink_span)
}

///|
/// Shrink implementation for Declaration.
/// Shrinks the contained declaration type.
pub impl @qc.Shrink for Declaration with shrink(self) {
  match self {
    Combinator(c) =>
      @qc.Shrink::shrink(c).map(fn(c) { Declaration::Combinator(c) })
    Final(f) => @qc.Shrink::shrink(f).map(fn(f) { Declaration::Final(f) })
  }
}

///|
/// Shrink implementation for Schema.
/// Shrinks types, functions, and comments arrays.
pub impl @qc.Shrink for Schema with shrink(self) {
  // Try emptying types
  let without_types = if self.types.length() > 0 {
    Iter::singleton({ ..self, types: [] })
  } else {
    Iter::empty()
  }
  // Try emptying functions
  let without_functions = if self.functions.length() > 0 {
    Iter::singleton({ ..self, functions: [] })
  } else {
    Iter::empty()
  }
  // Try emptying comments
  let without_comments = if self.comments.length() > 0 {
    Iter::singleton({ ..self, comments: [] })
  } else {
    Iter::empty()
  }
  // Shrink types array
  let shrink_types = @qc.Shrink::shrink(self.types).map(fn(types) {
    { ..self, types, }
  })
  // Shrink functions array
  let shrink_functions = @qc.Shrink::shrink(self.functions).map(fn(functions) {
    { ..self, functions, }
  })
  // Shrink comments array
  let shrink_comments = @qc.Shrink::shrink(self.comments).map(fn(comments) {
    { ..self, comments, }
  })
  without_types
  .concat(without_functions)
  .concat(without_comments)
  .concat(shrink_types)
  .concat(shrink_functions)
  .concat(shrink_comments)
}
