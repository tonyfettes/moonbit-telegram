///|
async fn main {
  guard @sys.get_env_var("BOT_TOKEN") is Some(token) else {
    fail("BOT_TOKEN environment variable is not set")
  }
  let bot = @bot.Bot::new(token~)

  // Verify the bot token
  let me = bot.get_me()
  println("Bot started: @\{me.username.unwrap()}")

  // Main loop
  let mut offset = 0
  while true {
    let updates = bot.get_updates(offset~)
    for update in updates {
      offset = update.update_id + 1
      if update.message is Some(msg) {
        if msg.text is Some(text) {
          bot.send_message(chat_id=msg.chat.id, text~) |> ignore()
        }
      }
    }
  }
}
