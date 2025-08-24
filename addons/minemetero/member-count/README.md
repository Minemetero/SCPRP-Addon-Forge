# Server Member Count -> Discord

## ✨ Features
- Reports current server member count every N minutes (default: 15)
- Optional: send only when the count changes
- Two modes:
  - **Raw number only** → just the number, easy for Discord bots to parse
  - **Embed** → color, title, and timestamp, optionally with sample player names

---

## ⚙️ Configuration

```lua
local CONFIG = {
    WEBHOOK_URL = "https://discord.com/api/webhooks/XXXX/REPLACE_ME",
    INTERVAL_MINUTES = 15,   -- how often to send (minutes)
    ONLY_ON_CHANGE   = true, -- only send when count changes
    RAW_NUMBER_ONLY  = true, -- true = send ONLY the number
}
