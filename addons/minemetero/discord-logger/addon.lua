----------------------------------------------------------------------
-- Discord Logger (API-updated)
-- Author: minemetero (updated by ChatGPT)
-- Version: 1.1.0
-- Logs: join, leave, chat, death, kill
-- Notes:
--  - Uses event() listeners only (no forever loops).
--  - Payloads built with jsonEncode for safe escaping.
----------------------------------------------------------------------

-------------------------------
-- Config
-------------------------------
local WEBHOOK_URL = "https://discord.com/api/webhooks/XXXX/REPLACE_ME"

-- Embed colors (decimal RGB)
local COLOR_JOIN   = 0x00FF00   -- green
local COLOR_LEAVE  = 0xFF0000   -- red
local COLOR_CHAT   = 0x808080   -- gray
local COLOR_DEATH  = 0x000000   -- black
local COLOR_KILL   = 0xFF9900   -- orange

-------------------------------
-- Helpers
-------------------------------
local function nowISO()
    local t = os.date("!*t")
    return string.format("%04d-%02d-%02dT%02d:%02d:%02dZ", t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function sendEmbed(title, description, color)
    -- Build with jsonEncode
    local payload = {
        embeds = {
            {
                title = tostring(title),
                description = tostring(description),
                color = tonumber(color) or 0,
                timestamp = nowISO(),
            }
        }
    }
    local body = jsonEncode(payload)
    http(WEBHOOK_URL, "post", { ["Content-Type"] = "application/json" }, body)
end

-------------------------------
-- Events
-------------------------------
-- joined: data.Value = playerName
event("joined", function(data)
    local player = tostring(data.Value)
    sendEmbed("✅ Player Joined", player .. " entered the server.", COLOR_JOIN)
end)

-- left: data.Value = playerName
event("left", function(data)
    local player = tostring(data.Value)
    sendEmbed("❌ Player Left", player .. " left the server.", COLOR_LEAVE)
end)

-- chatted: data.Value = { player = string, message = string }
event("chatted", function(data)
    local p = tostring(data.Value.player or data.Value[1])
    local m = tostring(data.Value.message or data.Value[2])
    sendEmbed("💬 Chat", p .. ": " .. m, COLOR_CHAT)
end)

-- death: data.Value = playerName
event("death", function(data)
    local player = tostring(data.Value)
    sendEmbed("☠️ Player Died", player .. " has died.", COLOR_DEATH)
end)

-- kill: data.Value = { killer = string, victim = string }
event("kill", function(data)
    local k = tostring(data.Value.killer)
    local v = tostring(data.Value.victim)
    if k and v then
        sendEmbed("🔪 Kill", k .. " eliminated " .. v .. ".", COLOR_KILL)
    end
end)
