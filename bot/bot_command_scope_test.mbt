///|
test "BotCommandScope Default JSON round-trip" {
  let obj : BotCommandScope = Default
  let json = @json.to_json(obj)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="Default")
}

///|
test "BotCommandScope AllPrivateChats JSON round-trip" {
  let obj : BotCommandScope = AllPrivateChats
  let json = @json.to_json(obj)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllPrivateChats")
}

///|
test "BotCommandScope AllGroupChats JSON round-trip" {
  let obj : BotCommandScope = AllGroupChats
  let json = @json.to_json(obj)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllGroupChats")
}

///|
test "BotCommandScope AllChatAdministrators JSON round-trip" {
  let obj : BotCommandScope = AllChatAdministrators
  let json = @json.to_json(obj)
  let parsed : BotCommandScope = @json.from_json(json)
  inspect(parsed, content="AllChatAdministrators")
}

///|
test "BotCommandScope Chat JSON round-trip" {
  let obj : BotCommandScope = Chat({ chat_id: 123L })
  let json = @json.to_json(obj)
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is Chat(v) else { fail("Expected Chat") }
  inspect(v.chat_id, content="123")
}

///|
test "BotCommandScope ChatAdministrators JSON round-trip" {
  let obj : BotCommandScope = ChatAdministrators({ chat_id: 456L })
  let json = @json.to_json(obj)
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is ChatAdministrators(v) else {
    fail("Expected ChatAdministrators")
  }
  inspect(v.chat_id, content="456")
}

///|
test "BotCommandScope ChatMember JSON round-trip" {
  let obj : BotCommandScope = ChatMember({ chat_id: 123L, user_id: 456L })
  let json = @json.to_json(obj)
  let parsed : BotCommandScope = @json.from_json(json)
  guard parsed is ChatMember(v) else { fail("Expected ChatMember") }
  inspect(v.chat_id, content="123")
  inspect(v.user_id, content="456")
}

///|
test "BotCommandScopeChat new constructor" {
  let obj = BotCommandScopeChat::new(chat_id=789L)
  inspect(obj.chat_id, content="789")
}

///|
test "BotCommandScopeChatAdministrators new constructor" {
  let obj = BotCommandScopeChatAdministrators::new(chat_id=789L)
  inspect(obj.chat_id, content="789")
}

///|
test "BotCommandScopeChatMember new constructor" {
  let obj = BotCommandScopeChatMember::new(chat_id=123L, user_id=456L)
  inspect(obj.chat_id, content="123")
  inspect(obj.user_id, content="456")
}
