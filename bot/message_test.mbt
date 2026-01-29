///|
test "Message JSON round-trip" {
  let message : Message = Message::new(
    message_id=789,
    from=@bot.User::new(
      id=123L,
      is_bot=false,
      first_name="John",
      last_name="Doe",
      username="johndoe",
      language_code="en",
    ),
    date=1640000000,
    chat=Chat::new(
      id=456L,
      type_=Private,
      username="johndoe",
      first_name="John",
      last_name="Doe",
    ),
    text="Hello, world!",
  )
  let json = @json.to_json(message)
  let parsed : Message = @json.from_json(json)
  inspect(parsed.message_id, content="789")
  inspect(parsed.text, content="Some(\"Hello, world!\")")
}

test "Message with new fields JSON round-trip" {
  let direct_topic = DirectMessagesTopic::new(
    id~ = 1,
    name~ = "Support",
    icon_color~ = 16711680,
  )

  let sticker = StickerPlaceholder::new(
    file_id~ = "abc123",
    file_unique_id~ = "unique123",
    width~ = 512,
    height~ = 512,
  )

  let gift = Gift::new(
    id~ = "gift_id_123",
    sticker~ = sticker,
    star_count~ = 100,
  )

  let gift_info = GiftInfo::new(
    gift~ = gift,
    from~ = None,
  )

  let message : Message = Message::new(
    message_id~ = 790,
    from~ = None,
    date~ = 1640000001,
    chat~ = Chat::new(
      id~ = 457L,
      type_~ = Private,
      username~ = "janedoe",
      first_name~ = "Jane",
      last_name~ = "Doe",
    ),
    text~ = Some("Test message with new fields"),
    entities~ = None,
    reply_to_message~ = None,
    message_thread_id~ = Some(5),
    is_topic_message~ = Some(true),
    direct_messages_topic~ = Some(direct_topic),
    gift_upgrade_sent~ = Some(gift_info),
    gift_id~ = Some("gift_123"),
    is_from_blockchain~ = Some(true),
  )

  let json = @json.to_json(message)
  let parsed : Message = @json.from_json(json, path=[])

  @test.eq?(parsed.message_id, 790)
  @test.eq?(parsed.message_thread_id, Some(5))
  @test.eq?(parsed.is_topic_message, Some(true))
  @test.eq?(parsed.gift_id, Some("gift_123"))
  @test.eq?(parsed.is_from_blockchain, Some(true))
}

test "Message with direct_messages_topic field" {
  let direct_topic = DirectMessagesTopic::new(
    id~ = 2,
    name~ = "General",
    icon_color~ = 65280,
  )

  let message : Message = Message::new(
    message_id~ = 791,
    from~ = None,
    date~ = 1640000002,
    chat~ = Chat::new(
      id~ = 458L,
      type_~ = Private,
      username~ = "bob",
      first_name~ = "Bob",
    ),
    text~ = Some("Message with topic"),
    entities~ = None,
    reply_to_message~ = None,
    message_thread_id~ = None,
    is_topic_message~ = None,
    direct_messages_topic~ = Some(direct_topic),
    gift_upgrade_sent~ = None,
    gift_id~ = None,
    is_from_blockchain~ = None,
  )

  let json_obj = @json.to_json(message)
  let json_str = @json.encode(json_obj)

  let parsed_json = @json.parse(json_str) |> @test.unwrap!
  let reconstructed : Message = @json.from_json(parsed_json, path=[])

  @test.eq?(reconstructed.direct_messages_topic.is_some(), true)
  let reconstructed_topic = reconstructed.direct_messages_topic |> @test.unwrap!
  @test.eq?(reconstructed_topic.id, 2)
  @test.eq?(reconstructed_topic.name, "General")
  @test.eq?(reconstructed_topic.icon_color, 65280)
}
