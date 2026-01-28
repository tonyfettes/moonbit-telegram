///|
/// Errors that can occur during TL parsing.
pub(all) suberror TLParseError {
  UnexpectedChar(pos~ : @ast.Position, char~ : Char)
  UnexpectedToken(pos~ : @ast.Position, expected~ : String, found~ : String)
  UnexpectedEof(pos~ : @ast.Position)
  InvalidHexId(pos~ : @ast.Position, value~ : String)
  InvalidNumber(pos~ : @ast.Position, value~ : String)
} derive(Show, Eq)
