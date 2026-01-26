# tonyfettes/telegram

MoonBit Telegram Bot API library with async support.

## Features

- Typed wrappers around the Telegram Bot HTTP API
- Async support via `moonbitlang/async`
- Long-polling with `get_updates`
- Inline keyboards and callback queries
- Bot commands menu

## Installation

```bash
moon add tonyfettes/telegram
```

Add to your `moon.pkg.json`:

```json
{
  "import": [
    "tonyfettes/telegram/bot",
    "moonbitlang/async"
  ]
}
```

## Quick Start

```moonbit
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
```

Run with:

```bash
BOT_TOKEN="your_token_here" moon run .
```

## Documentation

See [TUTORIAL.md](TUTORIAL.md) for a step-by-step guide covering:

- Echo bot basics
- Bot commands (`/scream`, `/whisper`)
- Inline keyboards and callback queries
- Message copying

## API Overview

### Bot Methods

| Method | Description |
|--------|-------------|
| `Bot::new(token~)` | Create a new bot instance |
| `get_me()` | Test bot token, returns `User` |
| `send_message(chat_id~, text~, ...)` | Send a text message |
| `copy_message(chat_id~, from_chat_id~, message_id~)` | Copy a message |
| `edit_message_text(chat_id~, message_id~, text~, ...)` | Edit message text |
| `answer_callback_query(callback_query_id~, ...)` | Answer button press |
| `set_my_commands(commands~)` | Set bot command menu |
| `get_updates(offset?, ...)` | Long-poll for updates |

### Types

| Type | Description |
|------|-------------|
| `Update` | Incoming update (message, callback_query, etc.) |
| `Message` | A message with text, from, chat, etc. |
| `User` | A Telegram user |
| `Chat` | A chat (private, group, etc.) |
| `CallbackQuery` | Button press from inline keyboard |
| `InlineKeyboardMarkup` | Inline keyboard layout |
| `InlineKeyboardButton` | A button with text and callback_data or url |
| `BotCommand` | Command shown in bot menu |

## License

Apache-2.0
