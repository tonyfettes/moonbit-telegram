///|
/// Property: parse(schema_to_string(schema)) == schema (ignoring spans)
///
/// Note: This test may fail due to known AST normalization issues:
/// - Variable references that aren't declared in opt_args
/// - Conditional references to non-existent flags fields
///
/// These failures document real issues in the AST representation that
/// could be addressed by normalizing the AST or refactoring it.
test "parse/print round-trip preserves schema structure" {
  @qc.quick_check(
    @qc.forall_shrink(@internal_qc.gen_schema(), @qc.Shrink::shrink, fn(
      schema,
    ) {
      let printed = @tl.schema_to_string(schema)
      let reparsed = try? @tl.parse(source=printed)
      match reparsed {
        Ok(parsed_schema) => @internal_qc.schema_equal(schema, parsed_schema)
        Err(_) => false
      }
    }),
    max_success=100,
    max_size=20,
  )
}
