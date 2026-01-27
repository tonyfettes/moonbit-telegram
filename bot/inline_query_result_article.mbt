///|
pub struct LinkPreviewOptions {
  is_disabled : Bool?
  url : String?
  prefer_small_media : Bool?
  prefer_large_media : Bool?
  show_above_text : Bool?
} derive(Show, Eq)

///|
pub fn LinkPreviewOptions::new(
  is_disabled? : Bool,
  url? : String,
  prefer_small_media? : Bool,
  prefer_large_media? : Bool,
  show_above_text? : Bool,
) -> LinkPreviewOptions {
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
pub impl @json.ToJson for LinkPreviewOptions with to_json(self) {
  let obj : Map[String, Json] = {}
  if self.is_disabled is Some(v) {
    obj["is_disabled"] = @json.to_json(v)
  }
  if self.url is Some(v) {
    obj["url"] = @json.to_json(v)
  }
  if self.prefer_small_media is Some(v) {
    obj["prefer_small_media"] = @json.to_json(v)
  }
  if self.prefer_large_media is Some(v) {
    obj["prefer_large_media"] = @json.to_json(v)
  }
  if self.show_above_text is Some(v) {
    obj["show_above_text"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for LinkPreviewOptions with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for LinkPreviewOptions")
  }
  let is_disabled : Bool? = if obj.get("is_disabled") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let url : String? = if obj.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_small_media : Bool? = if obj.get("prefer_small_media") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let prefer_large_media : Bool? = if obj.get("prefer_large_media") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let show_above_text : Bool? = if obj.get("show_above_text") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { is_disabled, url, prefer_small_media, prefer_large_media, show_above_text }
}

///|
pub struct InputTextMessageContent {
  message_text : String
  parse_mode : String?
  entities : Array[MessageEntity]?
  link_preview_options : LinkPreviewOptions?
} derive(Show, Eq)

///|
pub fn InputTextMessageContent::new(
  message_text~ : String,
  parse_mode? : String,
  entities? : Array[MessageEntity],
  link_preview_options? : LinkPreviewOptions,
) -> InputTextMessageContent {
  { message_text, parse_mode, entities, link_preview_options }
}

///|
pub impl @json.ToJson for InputTextMessageContent with to_json(self) {
  let obj : Map[String, Json] = {
    "message_text": @json.to_json(self.message_text),
  }
  if self.parse_mode is Some(v) {
    obj["parse_mode"] = @json.to_json(v)
  }
  if self.entities is Some(v) {
    obj["entities"] = @json.to_json(v)
  }
  if self.link_preview_options is Some(v) {
    obj["link_preview_options"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InputTextMessageContent with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InputTextMessageContent",
    )
  }
  let message_text : String = @json.from_json(obj["message_text"], path~)
  let parse_mode : String? = if obj.get("parse_mode") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let entities : Array[MessageEntity]? = if obj.get("entities") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let link_preview_options : LinkPreviewOptions? = if obj.get(
      "link_preview_options",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  { message_text, parse_mode, entities, link_preview_options }
}

///|
pub struct InlineQueryResultArticle {
  type_ : String
  id : String
  title : String
  input_message_content : InputTextMessageContent
  reply_markup : InlineKeyboardMarkup?
  url : String?
  hide_url : Bool?
  description : String?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultArticle::new(
  id~ : String,
  title~ : String,
  input_message_content~ : InputTextMessageContent,
  type_? : String = "article",
  reply_markup? : InlineKeyboardMarkup,
  url? : String,
  hide_url? : Bool,
  description? : String,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultArticle {
  {
    type_,
    id,
    title,
    input_message_content,
    reply_markup,
    url,
    hide_url,
    description,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultArticle with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "title": @json.to_json(self.title),
    "input_message_content": @json.to_json(self.input_message_content),
  }
  if self.reply_markup is Some(v) {
    obj["reply_markup"] = @json.to_json(v)
  }
  if self.url is Some(v) {
    obj["url"] = @json.to_json(v)
  }
  if self.hide_url is Some(v) {
    obj["hide_url"] = @json.to_json(v)
  }
  if self.description is Some(v) {
    obj["description"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    obj["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    obj["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    obj["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InlineQueryResultArticle with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultArticle",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let id : String = @json.from_json(obj["id"], path~)
  let title : String = @json.from_json(obj["title"], path~)
  let input_message_content : InputTextMessageContent = @json.from_json(
    obj["input_message_content"],
    path~,
  )
  let reply_markup : InlineKeyboardMarkup? = if obj.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let url : String? = if obj.get("url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let hide_url : Bool? = if obj.get("hide_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let description : String? = if obj.get("description") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if obj.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if obj.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if obj.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    title,
    input_message_content,
    reply_markup,
    url,
    hide_url,
    description,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub struct InlineQueryResultContact {
  type_ : String
  id : String
  phone_number : String
  first_name : String
  last_name : String?
  vcard : String?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultContact::new(
  id~ : String,
  phone_number~ : String,
  first_name~ : String,
  type_? : String = "contact",
  last_name? : String,
  vcard? : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultContact {
  {
    type_,
    id,
    phone_number,
    first_name,
    last_name,
    vcard,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultContact with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "phone_number": @json.to_json(self.phone_number),
    "first_name": @json.to_json(self.first_name),
  }
  if self.last_name is Some(v) {
    obj["last_name"] = @json.to_json(v)
  }
  if self.vcard is Some(v) {
    obj["vcard"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    obj["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    obj["input_message_content"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    obj["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    obj["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    obj["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InlineQueryResultContact with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultContact",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let id : String = @json.from_json(obj["id"], path~)
  let phone_number : String = @json.from_json(obj["phone_number"], path~)
  let first_name : String = @json.from_json(obj["first_name"], path~)
  let last_name : String? = if obj.get("last_name") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let vcard : String? = if obj.get("vcard") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if obj.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputTextMessageContent? = if obj.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if obj.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if obj.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if obj.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    phone_number,
    first_name,
    last_name,
    vcard,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub struct InlineQueryResultLocation {
  type_ : String
  id : String
  latitude : Double
  longitude : Double
  title : String
  horizontal_accuracy : Double?
  live_period : Int?
  heading : Int?
  proximity_alert_radius : Int?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultLocation::new(
  id~ : String,
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  type_? : String = "location",
  horizontal_accuracy? : Double,
  live_period? : Int,
  heading? : Int,
  proximity_alert_radius? : Int,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultLocation {
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultLocation with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "latitude": @json.to_json(self.latitude),
    "longitude": @json.to_json(self.longitude),
    "title": @json.to_json(self.title),
  }
  if self.horizontal_accuracy is Some(v) {
    obj["horizontal_accuracy"] = @json.to_json(v)
  }
  if self.live_period is Some(v) {
    obj["live_period"] = @json.to_json(v)
  }
  if self.heading is Some(v) {
    obj["heading"] = @json.to_json(v)
  }
  if self.proximity_alert_radius is Some(v) {
    obj["proximity_alert_radius"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    obj["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    obj["input_message_content"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    obj["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    obj["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    obj["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InlineQueryResultLocation with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultLocation",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let id : String = @json.from_json(obj["id"], path~)
  let latitude : Double = @json.from_json(obj["latitude"], path~)
  let longitude : Double = @json.from_json(obj["longitude"], path~)
  let title : String = @json.from_json(obj["title"], path~)
  let horizontal_accuracy : Double? = if obj.get("horizontal_accuracy")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let live_period : Int? = if obj.get("live_period") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let heading : Int? = if obj.get("heading") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let proximity_alert_radius : Int? = if obj.get("proximity_alert_radius")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if obj.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputTextMessageContent? = if obj.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if obj.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if obj.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if obj.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    horizontal_accuracy,
    live_period,
    heading,
    proximity_alert_radius,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub struct InlineQueryResultVenue {
  type_ : String
  id : String
  latitude : Double
  longitude : Double
  title : String
  address : String
  foursquare_id : String?
  foursquare_type : String?
  google_place_id : String?
  google_place_type : String?
  reply_markup : InlineKeyboardMarkup?
  input_message_content : InputTextMessageContent?
  thumbnail_url : String?
  thumbnail_width : Int?
  thumbnail_height : Int?
} derive(Show, Eq)

///|
pub fn InlineQueryResultVenue::new(
  id~ : String,
  latitude~ : Double,
  longitude~ : Double,
  title~ : String,
  address~ : String,
  type_? : String = "venue",
  foursquare_id? : String,
  foursquare_type? : String,
  google_place_id? : String,
  google_place_type? : String,
  reply_markup? : InlineKeyboardMarkup,
  input_message_content? : InputTextMessageContent,
  thumbnail_url? : String,
  thumbnail_width? : Int,
  thumbnail_height? : Int,
) -> InlineQueryResultVenue {
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}

///|
pub impl @json.ToJson for InlineQueryResultVenue with to_json(self) {
  let obj : Map[String, Json] = {
    "type": @json.to_json(self.type_),
    "id": @json.to_json(self.id),
    "latitude": @json.to_json(self.latitude),
    "longitude": @json.to_json(self.longitude),
    "title": @json.to_json(self.title),
    "address": @json.to_json(self.address),
  }
  if self.foursquare_id is Some(v) {
    obj["foursquare_id"] = @json.to_json(v)
  }
  if self.foursquare_type is Some(v) {
    obj["foursquare_type"] = @json.to_json(v)
  }
  if self.google_place_id is Some(v) {
    obj["google_place_id"] = @json.to_json(v)
  }
  if self.google_place_type is Some(v) {
    obj["google_place_type"] = @json.to_json(v)
  }
  if self.reply_markup is Some(v) {
    obj["reply_markup"] = @json.to_json(v)
  }
  if self.input_message_content is Some(v) {
    obj["input_message_content"] = @json.to_json(v)
  }
  if self.thumbnail_url is Some(v) {
    obj["thumbnail_url"] = @json.to_json(v)
  }
  if self.thumbnail_width is Some(v) {
    obj["thumbnail_width"] = @json.to_json(v)
  }
  if self.thumbnail_height is Some(v) {
    obj["thumbnail_height"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for InlineQueryResultVenue with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for InlineQueryResultVenue",
    )
  }
  let type_ : String = @json.from_json(obj["type"], path~)
  let id : String = @json.from_json(obj["id"], path~)
  let latitude : Double = @json.from_json(obj["latitude"], path~)
  let longitude : Double = @json.from_json(obj["longitude"], path~)
  let title : String = @json.from_json(obj["title"], path~)
  let address : String = @json.from_json(obj["address"], path~)
  let foursquare_id : String? = if obj.get("foursquare_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let foursquare_type : String? = if obj.get("foursquare_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_id : String? = if obj.get("google_place_id") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let google_place_type : String? = if obj.get("google_place_type") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let reply_markup : InlineKeyboardMarkup? = if obj.get("reply_markup")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let input_message_content : InputTextMessageContent? = if obj.get(
      "input_message_content",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_url : String? = if obj.get("thumbnail_url") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_width : Int? = if obj.get("thumbnail_width") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let thumbnail_height : Int? = if obj.get("thumbnail_height") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    type_,
    id,
    latitude,
    longitude,
    title,
    address,
    foursquare_id,
    foursquare_type,
    google_place_id,
    google_place_type,
    reply_markup,
    input_message_content,
    thumbnail_url,
    thumbnail_width,
    thumbnail_height,
  }
}
