///|
async fn main {
  guard @sys.get_env_var("BOT_TOKEN") is Some(token) else {
    println("Please set the BOT_TOKEN environment variable.")
    return
  }
  let bot = @bot.Bot::new(token~)
  let me = bot.get_me()
  println("Bot started: @\{me.username.unwrap()}")
  bot.set_my_commands(commands=[
    @bot.BotCommand::new(command="scream", description="Make the bot SCREAM"),
    @bot.BotCommand::new(command="whisper", description="Make the bot whisper"),
    @bot.BotCommand::new(command="menu", description="Show menu"),
  ])
  |> ignore()

  // Define keyboards
  let keyboard_menu1 = @bot.InlineKeyboardMarkup::new(inline_keyboard=[
    [@bot.InlineKeyboardButton::new(text="Next", callback_data="next")],
  ])
  let keyboard_menu2 = @bot.InlineKeyboardMarkup::new(inline_keyboard=[
    [
      @bot.InlineKeyboardButton::new(text="Back", callback_data="back"),
      @bot.InlineKeyboardButton::new(
        text="Tutorial",
        url="https://core.telegram.org/bots/tutorial",
      ),
    ],
  ])
  let screaming : Ref[Bool] = { val: false }
  let mut offset = 0
  while true {
    let updates = bot.get_updates(offset~)
    for update in updates {
      offset = update.update_id + 1

      // Handle messages
      if update.message is Some(msg) {
        if msg.text is Some(text) {
          if text.has_prefix("/scream") {
            screaming.val = true
          } else if text.has_prefix("/whisper") {
            screaming.val = false
          } else if text.has_prefix("/menu") {
            // Send menu
            bot.send_message(
              chat_id=msg.chat.id,
              text="<b>Menu 1</b>",
              parse_mode="HTML",
              reply_markup=keyboard_menu1,
            )
            |> ignore()
          } else if not(text.has_prefix("/")) {
            let response = if screaming.val { text.to_upper() } else { text }
            bot.send_message(chat_id=msg.chat.id, text=response) |> ignore()
          }
        }
      }

      // Handle callback queries (button presses)
      if update.callback_query is Some(query) {
        // Answer the callback to remove loading state
        bot.answer_callback_query(callback_query_id=query.id) |> ignore()

        // Get the message to edit
        if query.message is Some(msg) {
          if query.data is Some(data) {
            match data {
              "next" =>
                bot.edit_message_text(
                  chat_id=msg.chat.id,
                  message_id=msg.message_id,
                  text="<b>Menu 2</b>",
                  parse_mode="HTML",
                  reply_markup=keyboard_menu2,
                )
                |> ignore()
              "back" =>
                bot.edit_message_text(
                  chat_id=msg.chat.id,
                  message_id=msg.message_id,
                  text="<b>Menu 1</b>",
                  parse_mode="HTML",
                  reply_markup=keyboard_menu1,
                )
                |> ignore()
              _ => ()
            }
          }
        }
      }
    }
  }
}
