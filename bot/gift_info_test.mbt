test "GiftInfo JSON round-trip" {
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

  let original = GiftInfo::new(
    gift~ = gift,
    from~ = None,
  )

  let json = @json.to_json(original)
  let decoded = @json.from_json[GiftInfo](json, path=[])

  @test.eq?(decoded.gift.id, original.gift.id)
  @test.eq?(decoded.gift.star_count, original.gift.star_count)
  @test.eq?(decoded.from, None)
}

test "GiftInfo ToJson and FromJson with user" {
  let sticker = StickerPlaceholder::new(
    file_id~ = "xyz789",
    file_unique_id~ = "unique789",
    width~ = 256,
    height~ = 256,
  )

  let gift = Gift::new(
    id~ = "gift_id_456",
    sticker~ = sticker,
    star_count~ = 500,
    total_count~ = Some(1000),
    remaining_count~ = Some(500),
  )

  let user = User::new(
    id~ = 123456789L,
    is_bot~ = false,
    first_name~ = "John",
  )

  let gift_info = GiftInfo::new(
    gift~ = gift,
    from~ = Some(user),
  )

  let json_obj = @json.to_json(gift_info)
  let json_str = @json.encode(json_obj)

  let parsed_json = @json.parse(json_str) |> @test.unwrap!
  let reconstructed = @json.from_json[GiftInfo](parsed_json, path=[])

  @test.eq?(reconstructed.gift.id, "gift_id_456")
  @test.eq?(reconstructed.gift.star_count, 500)
  @test.eq?(reconstructed.from.is_some(), true)
}
