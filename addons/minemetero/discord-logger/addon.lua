----------------------------------------------------------------------
-- Discord Logger
-- Author: minemetero
-- Version: 1.0.0
-- Features:
--  - Logs: join, leave, chat, death
--  - Discord embeds with timestamp
--  - Color-coded embeds per event
--  - Continuous monitoring of deaths
----------------------------------------------------------------------

------------------------------------------------------
-- Helpers
------------------------------------------------------

local WEBHOOK_URL = "https://discord.com/api/webhooks/XXXX/REPLACE_ME"

local function nowISO()
    local t = os.date("!*t")
    return string.format("%04d-%02d-%02dT%02d:%02d:%02dZ", t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function sendEmbed(title, description, color)
    local payload = ('{"embeds":[{"title":%q,"description":%q,"color":%d,"timestamp":%q}]}')
        :format(title, description, color, nowISO())
    http(WEBHOOK_URL, "post", {["Content-Type"]="application/json"}, payload)
end

------------------------------------------------------
-- Events
------------------------------------------------------

event("joined", function(data)
    sendEmbed("✅ Player Joined", tostring(data.Value) .. " entered the server.", 65280)
end)

event("left", function(data)
    sendEmbed("❌ Player Left", tostring(data.Value) .. " left the server.", 16711680)
end)

event("chatted", function(data)
    local p, m = data.Value[1], data.Value[2]
    sendEmbed("💬 Chat", tostring(p) .. ": " .. tostring(m), 8421504)
end)

------------------------------------------------------
-- Death Tracking
------------------------------------------------------

task.spawn(function()
    local dead = {}
    while true do
        for _, name in ipairs(getPlayers()) do
            local hp = getPlayerHealth(name)
            if hp and hp <= 0 then
                if not dead[name] then
                    dead[name] = true
                    sendEmbed("☠️ Player Died", tostring(name) .. " has died.", 0)
                end
            else
                dead[name] = nil
            end
        end
        task.wait(0.5)
    end
end)
