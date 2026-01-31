///|
/// FFI bindings for command execution
extern "c" fn c_popen(command : Bytes, mode : Bytes) -> Int = "popen"
extern "c" fn c_pclose(stream : Int) -> Int = "pclose"
extern "c" fn c_fgets(buf : Bytes, size : Int, stream : Int) -> Int = "fgets"
extern "c" fn c_feof(stream : Int) -> Int = "feof"

///|
/// Run a shell command and return its output.
fn run_command(command : String) -> String {
  let cmd_bytes = @encoding/utf8.encode(command + "\u0000")
  let mode_bytes = @encoding/utf8.encode("r\u0000")
  let stream = c_popen(cmd_bytes, mode_bytes)
  if stream == 0 {
    return "Error: Failed to run command"
  }
  let output = StringBuilder::new()
  let buf_size = 1024
  let buf = Bytes::new(buf_size)
  while c_feof(stream) == 0 {
    let result = c_fgets(buf, buf_size, stream)
    if result == 0 {
      break
    }
    // Find null terminator and decode
    let mut len = 0
    for i in 0..<buf_size {
      if buf[i] == 0 {
        len = i
        break
      }
    }
    if len > 0 {
      // Decode bytes as ASCII (simple approach)
      for i in 0..<len {
        let c = buf[i].to_int()
        if c < 128 {
          output.write_char(c.unsafe_to_char())
        }
      }
    }
  }
  let _ = c_pclose(stream)
  let result = output.to_string()
  if result.is_empty() {
    "(no output)"
  } else {
    result
  }
}

///|
async fn send_reply(
  bot : @bot.Bot,
  chat_id : Int64,
  text : String
) -> Unit raise @bot.TelegramError {
  // Try with markdown first
  let response = "```\n" + text + "\n```"
  try {
    let _ = bot.send_message(chat_id~, text=response, parse_mode="MarkdownV2")
  } catch {
    @bot.TelegramError::ApiError(..) => {
      // Try without markdown
      let _ = bot.send_message(chat_id~, text~)
    }
    err => raise err
  }
}

///|
async fn main {
  let token = @sys.get_env_var("BOT_TOKEN")
  guard token is Some(t) else {
    println("Error: BOT_TOKEN environment variable is not set")
    return
  }
  let bot = @bot.Bot::new(token=t)
  
  // Verify the bot token
  let me = bot.get_me() catch {
    _ => {
      println("Failed to get bot info")
      return
    }
  }
  let username = me.username.unwrap_or("unknown")
  println("Bot started: @" + username)
  println("Send any command to execute in bash. Use with caution!")

  // Main loop
  let mut offset = 0
  while true {
    let updates = bot.get_updates(offset~, timeout=30) catch {
      _ => {
        println("Error getting updates")
        continue
      }
    }
    for update in updates {
      offset = update.update_id + 1
      if update.message is Some(msg) {
        if msg.text is Some(text) {
          let chat_id = msg.chat.id
          
          // Skip empty messages
          if text.is_empty() {
            continue
          }
          
          // Run the command
          let sender = match msg.from {
            Some(u) => u.username.unwrap_or(u.first_name)
            None => "unknown"
          }
          println("Running command from " + sender + ": " + text)
          let output = run_command(text)
          
          // Send result back (truncate if too long)
          let max_len = 4000
          let truncated = if output.length() > max_len {
            output[0:max_len].to_string() + "\n...(truncated)"
          } else {
            output
          }
          
          let _ = send_reply(bot, chat_id, truncated) catch { _ => () }
        }
      }
    }
  }
}
