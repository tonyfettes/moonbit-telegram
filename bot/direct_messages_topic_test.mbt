test "DirectMessagesTopic JSON round-trip" {
  let original = DirectMessagesTopic::new(
    id~ = 123,
    name~ = "Support",
    icon_color~ = 16711680,
  )

  let json = @json.to_json(original)
  let decoded = @json.from_json[DirectMessagesTopic](json, path=[])

  @test.eq?(decoded.id, original.id)
  @test.eq?(decoded.name, original.name)
  @test.eq?(decoded.icon_color, original.icon_color)
}

test "DirectMessagesTopic ToJson and FromJson" {
  let topic = DirectMessagesTopic::new(
    id~ = 456,
    name~ = "General",
    icon_color~ = 65280,
  )

  let json_obj = @json.to_json(topic)
  let json_str = @json.encode(json_obj)

  let parsed_json = @json.parse(json_str) |> @test.unwrap!
  let reconstructed = @json.from_json[DirectMessagesTopic](parsed_json, path=[])

  @test.eq?(reconstructed.id, 456)
  @test.eq?(reconstructed.name, "General")
  @test.eq?(reconstructed.icon_color, 65280)
}
