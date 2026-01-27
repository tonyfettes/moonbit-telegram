///|
pub struct ChatPhoto {
  small_file_id : String
  small_file_unique_id : String
  big_file_id : String
  big_file_unique_id : String
} derive(Show, Eq)

///|
pub fn ChatPhoto::new(
  small_file_id~ : String,
  small_file_unique_id~ : String,
  big_file_id~ : String,
  big_file_unique_id~ : String,
) -> ChatPhoto {
  { small_file_id, small_file_unique_id, big_file_id, big_file_unique_id }
}

///|
pub impl @json.ToJson for ChatPhoto with to_json(self) {
  let obj : Map[String, Json] = {
    "small_file_id": @json.to_json(self.small_file_id),
    "small_file_unique_id": @json.to_json(self.small_file_unique_id),
    "big_file_id": @json.to_json(self.big_file_id),
    "big_file_unique_id": @json.to_json(self.big_file_unique_id),
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ChatPhoto with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatPhoto")
  }
  let small_file_id : String = @json.from_json(obj["small_file_id"], path~)
  let small_file_unique_id : String = @json.from_json(
    obj["small_file_unique_id"],
    path~,
  )
  let big_file_id : String = @json.from_json(obj["big_file_id"], path~)
  let big_file_unique_id : String = @json.from_json(
    obj["big_file_unique_id"],
    path~,
  )
  { small_file_id, small_file_unique_id, big_file_id, big_file_unique_id }
}
