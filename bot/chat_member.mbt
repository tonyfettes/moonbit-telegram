///|
pub struct ChatMemberOwner {
  user : User
  is_anonymous : Bool
  custom_title : String?
} derive(Show, Eq)

///|
pub fn ChatMemberOwner::new(
  user~ : User,
  is_anonymous~ : Bool,
  custom_title? : String,
) -> ChatMemberOwner {
  { user, is_anonymous, custom_title }
}

///|
pub struct ChatMemberAdministrator {
  user : User
  can_be_edited : Bool
  is_anonymous : Bool
  can_manage_chat : Bool
  can_delete_messages : Bool
  can_manage_video_chats : Bool
  can_restrict_members : Bool
  can_promote_members : Bool
  can_change_info : Bool
  can_invite_users : Bool
  can_post_stories : Bool
  can_edit_stories : Bool
  can_delete_stories : Bool
  can_post_messages : Bool?
  can_edit_messages : Bool?
  can_pin_messages : Bool?
  can_manage_topics : Bool?
  custom_title : String?
} derive(Show, Eq)

///|
pub fn ChatMemberAdministrator::new(
  user~ : User,
  can_be_edited~ : Bool,
  is_anonymous~ : Bool,
  can_manage_chat~ : Bool,
  can_delete_messages~ : Bool,
  can_manage_video_chats~ : Bool,
  can_restrict_members~ : Bool,
  can_promote_members~ : Bool,
  can_change_info~ : Bool,
  can_invite_users~ : Bool,
  can_post_stories~ : Bool,
  can_edit_stories~ : Bool,
  can_delete_stories~ : Bool,
  can_post_messages? : Bool,
  can_edit_messages? : Bool,
  can_pin_messages? : Bool,
  can_manage_topics? : Bool,
  custom_title? : String,
) -> ChatMemberAdministrator {
  {
    user,
    can_be_edited,
    is_anonymous,
    can_manage_chat,
    can_delete_messages,
    can_manage_video_chats,
    can_restrict_members,
    can_promote_members,
    can_change_info,
    can_invite_users,
    can_post_stories,
    can_edit_stories,
    can_delete_stories,
    can_post_messages,
    can_edit_messages,
    can_pin_messages,
    can_manage_topics,
    custom_title,
  }
}

///|
pub struct ChatMemberMember {
  user : User
  until_date : Int?
} derive(Show, Eq)

///|
pub fn ChatMemberMember::new(
  user~ : User,
  until_date? : Int,
) -> ChatMemberMember {
  { user, until_date }
}

///|
pub struct ChatMemberRestricted {
  user : User
  is_member : Bool
  can_send_messages : Bool
  can_send_audios : Bool
  can_send_documents : Bool
  can_send_photos : Bool
  can_send_videos : Bool
  can_send_video_notes : Bool
  can_send_voice_notes : Bool
  can_send_polls : Bool
  can_send_other_messages : Bool
  can_add_web_page_previews : Bool
  can_change_info : Bool
  can_invite_users : Bool
  can_pin_messages : Bool
  can_manage_topics : Bool
  until_date : Int
} derive(Show, Eq)

///|
pub fn ChatMemberRestricted::new(
  user~ : User,
  is_member~ : Bool,
  can_send_messages~ : Bool,
  can_send_audios~ : Bool,
  can_send_documents~ : Bool,
  can_send_photos~ : Bool,
  can_send_videos~ : Bool,
  can_send_video_notes~ : Bool,
  can_send_voice_notes~ : Bool,
  can_send_polls~ : Bool,
  can_send_other_messages~ : Bool,
  can_add_web_page_previews~ : Bool,
  can_change_info~ : Bool,
  can_invite_users~ : Bool,
  can_pin_messages~ : Bool,
  can_manage_topics~ : Bool,
  until_date~ : Int,
) -> ChatMemberRestricted {
  {
    user,
    is_member,
    can_send_messages,
    can_send_audios,
    can_send_documents,
    can_send_photos,
    can_send_videos,
    can_send_video_notes,
    can_send_voice_notes,
    can_send_polls,
    can_send_other_messages,
    can_add_web_page_previews,
    can_change_info,
    can_invite_users,
    can_pin_messages,
    can_manage_topics,
    until_date,
  }
}

///|
pub struct ChatMemberLeft {
  user : User
} derive(Show, Eq)

///|
pub fn ChatMemberLeft::new(user~ : User) -> ChatMemberLeft {
  { user, }
}

///|
pub struct ChatMemberBanned {
  user : User
  until_date : Int
} derive(Show, Eq)

///|
pub fn ChatMemberBanned::new(
  user~ : User,
  until_date~ : Int,
) -> ChatMemberBanned {
  { user, until_date }
}

///|
pub(all) enum ChatMember {
  Owner(ChatMemberOwner)
  Administrator(ChatMemberAdministrator)
  Member(ChatMemberMember)
  Restricted(ChatMemberRestricted)
  Left(ChatMemberLeft)
  Banned(ChatMemberBanned)
} derive(Show, Eq)

///|
pub impl @json.ToJson for ChatMember with to_json(self) {
  match self {
    Owner(v) => {
      let obj : Map[String, Json] = {
        "status": "creator",
        "user": @json.to_json(v.user),
        "is_anonymous": @json.to_json(v.is_anonymous),
      }
      if v.custom_title is Some(t) {
        obj["custom_title"] = @json.to_json(t)
      }
      @json.to_json(obj)
    }
    Administrator(v) => {
      let obj : Map[String, Json] = {
        "status": "administrator",
        "user": @json.to_json(v.user),
        "can_be_edited": @json.to_json(v.can_be_edited),
        "is_anonymous": @json.to_json(v.is_anonymous),
        "can_manage_chat": @json.to_json(v.can_manage_chat),
        "can_delete_messages": @json.to_json(v.can_delete_messages),
        "can_manage_video_chats": @json.to_json(v.can_manage_video_chats),
        "can_restrict_members": @json.to_json(v.can_restrict_members),
        "can_promote_members": @json.to_json(v.can_promote_members),
        "can_change_info": @json.to_json(v.can_change_info),
        "can_invite_users": @json.to_json(v.can_invite_users),
        "can_post_stories": @json.to_json(v.can_post_stories),
        "can_edit_stories": @json.to_json(v.can_edit_stories),
        "can_delete_stories": @json.to_json(v.can_delete_stories),
      }
      if v.can_post_messages is Some(x) {
        obj["can_post_messages"] = @json.to_json(x)
      }
      if v.can_edit_messages is Some(x) {
        obj["can_edit_messages"] = @json.to_json(x)
      }
      if v.can_pin_messages is Some(x) {
        obj["can_pin_messages"] = @json.to_json(x)
      }
      if v.can_manage_topics is Some(x) {
        obj["can_manage_topics"] = @json.to_json(x)
      }
      if v.custom_title is Some(t) {
        obj["custom_title"] = @json.to_json(t)
      }
      @json.to_json(obj)
    }
    Member(v) => {
      let obj : Map[String, Json] = {
        "status": "member",
        "user": @json.to_json(v.user),
      }
      if v.until_date is Some(d) {
        obj["until_date"] = @json.to_json(d)
      }
      @json.to_json(obj)
    }
    Restricted(v) => {
      let obj : Map[String, Json] = {
        "status": "restricted",
        "user": @json.to_json(v.user),
        "is_member": @json.to_json(v.is_member),
        "can_send_messages": @json.to_json(v.can_send_messages),
        "can_send_audios": @json.to_json(v.can_send_audios),
        "can_send_documents": @json.to_json(v.can_send_documents),
        "can_send_photos": @json.to_json(v.can_send_photos),
        "can_send_videos": @json.to_json(v.can_send_videos),
        "can_send_video_notes": @json.to_json(v.can_send_video_notes),
        "can_send_voice_notes": @json.to_json(v.can_send_voice_notes),
        "can_send_polls": @json.to_json(v.can_send_polls),
        "can_send_other_messages": @json.to_json(v.can_send_other_messages),
        "can_add_web_page_previews": @json.to_json(v.can_add_web_page_previews),
        "can_change_info": @json.to_json(v.can_change_info),
        "can_invite_users": @json.to_json(v.can_invite_users),
        "can_pin_messages": @json.to_json(v.can_pin_messages),
        "can_manage_topics": @json.to_json(v.can_manage_topics),
        "until_date": @json.to_json(v.until_date),
      }
      @json.to_json(obj)
    }
    Left(v) => {
      let obj : Map[String, Json] = {
        "status": "left",
        "user": @json.to_json(v.user),
      }
      @json.to_json(obj)
    }
    Banned(v) => {
      let obj : Map[String, Json] = {
        "status": "kicked",
        "user": @json.to_json(v.user),
        "until_date": @json.to_json(v.until_date),
      }
      @json.to_json(obj)
    }
  }
}

///|
pub impl @json.FromJson for ChatMember with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatMember")
  }
  guard obj["status"] is String(status) else {
    raise @json.JsonDecodeError(path~, "Expected status field")
  }
  match status {
    "creator" => {
      let user : User = @json.from_json(obj["user"], path~)
      let is_anonymous : Bool = @json.from_json(obj["is_anonymous"], path~)
      let custom_title : String? = if obj.get("custom_title") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Owner(ChatMemberOwner::new(user~, is_anonymous~, custom_title?))
    }
    "administrator" => {
      let user : User = @json.from_json(obj["user"], path~)
      let can_be_edited : Bool = @json.from_json(obj["can_be_edited"], path~)
      let is_anonymous : Bool = @json.from_json(obj["is_anonymous"], path~)
      let can_manage_chat : Bool = @json.from_json(
        obj["can_manage_chat"],
        path~,
      )
      let can_delete_messages : Bool = @json.from_json(
        obj["can_delete_messages"],
        path~,
      )
      let can_manage_video_chats : Bool = @json.from_json(
        obj["can_manage_video_chats"],
        path~,
      )
      let can_restrict_members : Bool = @json.from_json(
        obj["can_restrict_members"],
        path~,
      )
      let can_promote_members : Bool = @json.from_json(
        obj["can_promote_members"],
        path~,
      )
      let can_change_info : Bool = @json.from_json(
        obj["can_change_info"],
        path~,
      )
      let can_invite_users : Bool = @json.from_json(
        obj["can_invite_users"],
        path~,
      )
      let can_post_stories : Bool = @json.from_json(
        obj["can_post_stories"],
        path~,
      )
      let can_edit_stories : Bool = @json.from_json(
        obj["can_edit_stories"],
        path~,
      )
      let can_delete_stories : Bool = @json.from_json(
        obj["can_delete_stories"],
        path~,
      )
      let can_post_messages : Bool? = if obj.get("can_post_messages") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let can_edit_messages : Bool? = if obj.get("can_edit_messages") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let can_pin_messages : Bool? = if obj.get("can_pin_messages") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let can_manage_topics : Bool? = if obj.get("can_manage_topics") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      let custom_title : String? = if obj.get("custom_title") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Administrator(
        ChatMemberAdministrator::new(
          user~,
          can_be_edited~,
          is_anonymous~,
          can_manage_chat~,
          can_delete_messages~,
          can_manage_video_chats~,
          can_restrict_members~,
          can_promote_members~,
          can_change_info~,
          can_invite_users~,
          can_post_stories~,
          can_edit_stories~,
          can_delete_stories~,
          can_post_messages?,
          can_edit_messages?,
          can_pin_messages?,
          can_manage_topics?,
          custom_title?,
        ),
      )
    }
    "member" => {
      let user : User = @json.from_json(obj["user"], path~)
      let until_date : Int? = if obj.get("until_date") is Some(v) {
        Some(@json.from_json(v, path~))
      } else {
        None
      }
      Member(ChatMemberMember::new(user~, until_date?))
    }
    "restricted" => {
      let user : User = @json.from_json(obj["user"], path~)
      let is_member : Bool = @json.from_json(obj["is_member"], path~)
      let can_send_messages : Bool = @json.from_json(
        obj["can_send_messages"],
        path~,
      )
      let can_send_audios : Bool = @json.from_json(
        obj["can_send_audios"],
        path~,
      )
      let can_send_documents : Bool = @json.from_json(
        obj["can_send_documents"],
        path~,
      )
      let can_send_photos : Bool = @json.from_json(
        obj["can_send_photos"],
        path~,
      )
      let can_send_videos : Bool = @json.from_json(
        obj["can_send_videos"],
        path~,
      )
      let can_send_video_notes : Bool = @json.from_json(
        obj["can_send_video_notes"],
        path~,
      )
      let can_send_voice_notes : Bool = @json.from_json(
        obj["can_send_voice_notes"],
        path~,
      )
      let can_send_polls : Bool = @json.from_json(obj["can_send_polls"], path~)
      let can_send_other_messages : Bool = @json.from_json(
        obj["can_send_other_messages"],
        path~,
      )
      let can_add_web_page_previews : Bool = @json.from_json(
        obj["can_add_web_page_previews"],
        path~,
      )
      let can_change_info : Bool = @json.from_json(
        obj["can_change_info"],
        path~,
      )
      let can_invite_users : Bool = @json.from_json(
        obj["can_invite_users"],
        path~,
      )
      let can_pin_messages : Bool = @json.from_json(
        obj["can_pin_messages"],
        path~,
      )
      let can_manage_topics : Bool = @json.from_json(
        obj["can_manage_topics"],
        path~,
      )
      let until_date : Int = @json.from_json(obj["until_date"], path~)
      Restricted(
        ChatMemberRestricted::new(
          user~,
          is_member~,
          can_send_messages~,
          can_send_audios~,
          can_send_documents~,
          can_send_photos~,
          can_send_videos~,
          can_send_video_notes~,
          can_send_voice_notes~,
          can_send_polls~,
          can_send_other_messages~,
          can_add_web_page_previews~,
          can_change_info~,
          can_invite_users~,
          can_pin_messages~,
          can_manage_topics~,
          until_date~,
        ),
      )
    }
    "left" => {
      let user : User = @json.from_json(obj["user"], path~)
      Left(ChatMemberLeft::new(user~))
    }
    "kicked" => {
      let user : User = @json.from_json(obj["user"], path~)
      let until_date : Int = @json.from_json(obj["until_date"], path~)
      Banned(ChatMemberBanned::new(user~, until_date~))
    }
    _ =>
      raise @json.JsonDecodeError(path~, "Unknown ChatMember status: " + status)
  }
}

///|
pub struct ChatPermissions {
  can_send_messages : Bool?
  can_send_audios : Bool?
  can_send_documents : Bool?
  can_send_photos : Bool?
  can_send_videos : Bool?
  can_send_video_notes : Bool?
  can_send_voice_notes : Bool?
  can_send_polls : Bool?
  can_send_other_messages : Bool?
  can_add_web_page_previews : Bool?
  can_change_info : Bool?
  can_invite_users : Bool?
  can_pin_messages : Bool?
  can_manage_topics : Bool?
} derive(Show, Eq)

///|
pub fn ChatPermissions::new(
  can_send_messages? : Bool,
  can_send_audios? : Bool,
  can_send_documents? : Bool,
  can_send_photos? : Bool,
  can_send_videos? : Bool,
  can_send_video_notes? : Bool,
  can_send_voice_notes? : Bool,
  can_send_polls? : Bool,
  can_send_other_messages? : Bool,
  can_add_web_page_previews? : Bool,
  can_change_info? : Bool,
  can_invite_users? : Bool,
  can_pin_messages? : Bool,
  can_manage_topics? : Bool,
) -> ChatPermissions {
  {
    can_send_messages,
    can_send_audios,
    can_send_documents,
    can_send_photos,
    can_send_videos,
    can_send_video_notes,
    can_send_voice_notes,
    can_send_polls,
    can_send_other_messages,
    can_add_web_page_previews,
    can_change_info,
    can_invite_users,
    can_pin_messages,
    can_manage_topics,
  }
}

///|
pub impl @json.ToJson for ChatPermissions with to_json(self) {
  let obj : Map[String, Json] = {}
  if self.can_send_messages is Some(v) {
    obj["can_send_messages"] = @json.to_json(v)
  }
  if self.can_send_audios is Some(v) {
    obj["can_send_audios"] = @json.to_json(v)
  }
  if self.can_send_documents is Some(v) {
    obj["can_send_documents"] = @json.to_json(v)
  }
  if self.can_send_photos is Some(v) {
    obj["can_send_photos"] = @json.to_json(v)
  }
  if self.can_send_videos is Some(v) {
    obj["can_send_videos"] = @json.to_json(v)
  }
  if self.can_send_video_notes is Some(v) {
    obj["can_send_video_notes"] = @json.to_json(v)
  }
  if self.can_send_voice_notes is Some(v) {
    obj["can_send_voice_notes"] = @json.to_json(v)
  }
  if self.can_send_polls is Some(v) {
    obj["can_send_polls"] = @json.to_json(v)
  }
  if self.can_send_other_messages is Some(v) {
    obj["can_send_other_messages"] = @json.to_json(v)
  }
  if self.can_add_web_page_previews is Some(v) {
    obj["can_add_web_page_previews"] = @json.to_json(v)
  }
  if self.can_change_info is Some(v) {
    obj["can_change_info"] = @json.to_json(v)
  }
  if self.can_invite_users is Some(v) {
    obj["can_invite_users"] = @json.to_json(v)
  }
  if self.can_pin_messages is Some(v) {
    obj["can_pin_messages"] = @json.to_json(v)
  }
  if self.can_manage_topics is Some(v) {
    obj["can_manage_topics"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ChatPermissions with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(path~, "Expected object for ChatPermissions")
  }
  let can_send_messages : Bool? = if obj.get("can_send_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_audios : Bool? = if obj.get("can_send_audios") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_documents : Bool? = if obj.get("can_send_documents") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_photos : Bool? = if obj.get("can_send_photos") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_videos : Bool? = if obj.get("can_send_videos") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_video_notes : Bool? = if obj.get("can_send_video_notes")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_voice_notes : Bool? = if obj.get("can_send_voice_notes")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_polls : Bool? = if obj.get("can_send_polls") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_send_other_messages : Bool? = if obj.get("can_send_other_messages")
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_add_web_page_previews : Bool? = if obj.get(
      "can_add_web_page_previews",
    )
    is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_change_info : Bool? = if obj.get("can_change_info") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_invite_users : Bool? = if obj.get("can_invite_users") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_pin_messages : Bool? = if obj.get("can_pin_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_manage_topics : Bool? = if obj.get("can_manage_topics") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    can_send_messages,
    can_send_audios,
    can_send_documents,
    can_send_photos,
    can_send_videos,
    can_send_video_notes,
    can_send_voice_notes,
    can_send_polls,
    can_send_other_messages,
    can_add_web_page_previews,
    can_change_info,
    can_invite_users,
    can_pin_messages,
    can_manage_topics,
  }
}

///|
pub struct ChatAdministratorRights {
  is_anonymous : Bool
  can_manage_chat : Bool
  can_delete_messages : Bool
  can_manage_video_chats : Bool
  can_restrict_members : Bool
  can_promote_members : Bool
  can_change_info : Bool
  can_invite_users : Bool
  can_post_stories : Bool
  can_edit_stories : Bool
  can_delete_stories : Bool
  can_post_messages : Bool?
  can_edit_messages : Bool?
  can_pin_messages : Bool?
  can_manage_topics : Bool?
} derive(Show, Eq)

///|
pub fn ChatAdministratorRights::new(
  is_anonymous~ : Bool,
  can_manage_chat~ : Bool,
  can_delete_messages~ : Bool,
  can_manage_video_chats~ : Bool,
  can_restrict_members~ : Bool,
  can_promote_members~ : Bool,
  can_change_info~ : Bool,
  can_invite_users~ : Bool,
  can_post_stories~ : Bool,
  can_edit_stories~ : Bool,
  can_delete_stories~ : Bool,
  can_post_messages? : Bool,
  can_edit_messages? : Bool,
  can_pin_messages? : Bool,
  can_manage_topics? : Bool,
) -> ChatAdministratorRights {
  {
    is_anonymous,
    can_manage_chat,
    can_delete_messages,
    can_manage_video_chats,
    can_restrict_members,
    can_promote_members,
    can_change_info,
    can_invite_users,
    can_post_stories,
    can_edit_stories,
    can_delete_stories,
    can_post_messages,
    can_edit_messages,
    can_pin_messages,
    can_manage_topics,
  }
}

///|
pub impl @json.ToJson for ChatAdministratorRights with to_json(self) {
  let obj : Map[String, Json] = {
    "is_anonymous": @json.to_json(self.is_anonymous),
    "can_manage_chat": @json.to_json(self.can_manage_chat),
    "can_delete_messages": @json.to_json(self.can_delete_messages),
    "can_manage_video_chats": @json.to_json(self.can_manage_video_chats),
    "can_restrict_members": @json.to_json(self.can_restrict_members),
    "can_promote_members": @json.to_json(self.can_promote_members),
    "can_change_info": @json.to_json(self.can_change_info),
    "can_invite_users": @json.to_json(self.can_invite_users),
    "can_post_stories": @json.to_json(self.can_post_stories),
    "can_edit_stories": @json.to_json(self.can_edit_stories),
    "can_delete_stories": @json.to_json(self.can_delete_stories),
  }
  if self.can_post_messages is Some(v) {
    obj["can_post_messages"] = @json.to_json(v)
  }
  if self.can_edit_messages is Some(v) {
    obj["can_edit_messages"] = @json.to_json(v)
  }
  if self.can_pin_messages is Some(v) {
    obj["can_pin_messages"] = @json.to_json(v)
  }
  if self.can_manage_topics is Some(v) {
    obj["can_manage_topics"] = @json.to_json(v)
  }
  @json.to_json(obj)
}

///|
pub impl @json.FromJson for ChatAdministratorRights with from_json(json, path) {
  guard json is Object(obj) else {
    raise @json.JsonDecodeError(
      path~,
      "Expected object for ChatAdministratorRights",
    )
  }
  let is_anonymous : Bool = @json.from_json(obj["is_anonymous"], path~)
  let can_manage_chat : Bool = @json.from_json(obj["can_manage_chat"], path~)
  let can_delete_messages : Bool = @json.from_json(
    obj["can_delete_messages"],
    path~,
  )
  let can_manage_video_chats : Bool = @json.from_json(
    obj["can_manage_video_chats"],
    path~,
  )
  let can_restrict_members : Bool = @json.from_json(
    obj["can_restrict_members"],
    path~,
  )
  let can_promote_members : Bool = @json.from_json(
    obj["can_promote_members"],
    path~,
  )
  let can_change_info : Bool = @json.from_json(obj["can_change_info"], path~)
  let can_invite_users : Bool = @json.from_json(obj["can_invite_users"], path~)
  let can_post_stories : Bool = @json.from_json(obj["can_post_stories"], path~)
  let can_edit_stories : Bool = @json.from_json(obj["can_edit_stories"], path~)
  let can_delete_stories : Bool = @json.from_json(
    obj["can_delete_stories"],
    path~,
  )
  let can_post_messages : Bool? = if obj.get("can_post_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_edit_messages : Bool? = if obj.get("can_edit_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_pin_messages : Bool? = if obj.get("can_pin_messages") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  let can_manage_topics : Bool? = if obj.get("can_manage_topics") is Some(v) {
    Some(@json.from_json(v, path~))
  } else {
    None
  }
  {
    is_anonymous,
    can_manage_chat,
    can_delete_messages,
    can_manage_video_chats,
    can_restrict_members,
    can_promote_members,
    can_change_info,
    can_invite_users,
    can_post_stories,
    can_edit_stories,
    can_delete_stories,
    can_post_messages,
    can_edit_messages,
    can_pin_messages,
    can_manage_topics,
  }
}
