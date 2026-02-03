# Bash Bot Example

A simple Telegram bot that executes shell commands and returns the output.

## ⚠️ Warning

This bot executes arbitrary shell commands. **Only run it in a secure environment** and ensure only trusted users have access to the bot.

## Usage

1. Set your Telegram bot token:
   ```bash
   export BOT_TOKEN="your_bot_token_here"
   ```

2. Build and run:
   ```bash
   moon run tonyfettes/telegram/example/bash-bot --target native
   ```

3. Send any shell command to your bot on Telegram:
   ```
   ls -la
   whoami
   date
   echo "Hello, World!"
   ```

The bot will execute the command and return the output in a code block.

## Features

- Executes commands via `popen()` (native target only)
- Returns output in Markdown code blocks
- Truncates output longer than 4000 characters
- Falls back to plain text if Markdown fails

## Limitations

- Only works with `--target native` (requires C FFI)
- No input support (only reads stdout)
- No stderr capture
- No command timeout
