----------------------------------------------------------------------
-- Server Member Count -> Discord
-- Author: minemetero
-- Version: 1.0.0
-- Features:
--  - Sends current online player count to a Discord webhook
--  - Embed mode (title/timestamp) OR "raw number only" mode
--  - Runs every N minutes (default 15)
--  - Optional: only send when the count changes
----------------------------------------------------------------------

------------------------------------------------------
-- Configuration
------------------------------------------------------
local CONFIG = {
  WEBHOOK_URL = "https://discord.com/api/webhooks/XXXX/REPLACE_ME",

  INTERVAL_MINUTES = 15,   -- how often to post
  ONLY_ON_CHANGE   = true, -- send only when count changes

  -- Raw number mode
  RAW_NUMBER_ONLY  = true, -- if true, message body is ONLY the number (e.g., "17")

  -- Embed settings (used when RAW_NUMBER_ONLY = false)
  EMBED_TITLE = "Server Member Count",
  EMBED_COLOR = 3447003,
  SHOW_SAMPLE_NAMES = false,
  SAMPLE_LIMIT       = 10,
}

------------------------------------------------------
-- Helpers
------------------------------------------------------
local function nowISO()
  local t = os.date("!*t")
  return string.format("%04d-%02d-%02dT%02d:%02d:%02dZ",
      t.year, t.month, t.day, t.hour, t.min, t.sec)
end

local function json_escape(s)
  s = tostring(s)
  s = s:gsub("\\", "\\\\")
  s = s:gsub('"', '\\"')
  s = s:gsub("\n", "\\n")
  s = s:gsub("\r", "\\r")
  return s
end

local function sendRawNumber(count)
  local content = tostring(tonumber(count) or 0)
  local payload = string.format('{"content":"%s"}', content)
  pcall(function()
      http(CONFIG.WEBHOOK_URL, "post", {["Content-Type"]="application/json"}, payload)
  end)
end

local function sendCountEmbed(count, sampleNames)
  local title = json_escape(CONFIG.EMBED_TITLE)
  local desc  = json_escape("Online players: " .. tostring(count))
  local ts    = json_escape(nowISO())

  local fieldsJson = ""
  if CONFIG.SHOW_SAMPLE_NAMES and sampleNames and #sampleNames > 0 then
      local list = table.concat(sampleNames, ", ")
      list = json_escape(list)
      fieldsJson = string.format(
          ',"fields":[{"name":"Players (sample)","value":"%s","inline":false}]',
          list
      )
  end

  local payload = string.format(
      '{"embeds":[{"title":"%s","description":"%s","color":%d,"timestamp":"%s"%s}]}',
      title, desc, CONFIG.EMBED_COLOR, ts, fieldsJson
  )

  pcall(function()
      http(CONFIG.WEBHOOK_URL, "post", {["Content-Type"]="application/json"}, payload)
  end)
end

------------------------------------------------------
-- Poster Loop
------------------------------------------------------
task.spawn(function()
  local lastCount = -1
  local intervalSeconds = CONFIG.INTERVAL_MINUTES * 60

  while true do
      local start = os.clock()

      local players = {}
      for _, name in ipairs(getPlayers()) do
          players[#players + 1] = name
      end
      local count = #players

      local shouldSend = true
      if CONFIG.ONLY_ON_CHANGE and count == lastCount then
          shouldSend = false
      end

      if shouldSend then
          if CONFIG.RAW_NUMBER_ONLY then
              sendRawNumber(count)
          else
              local sample = nil
              if CONFIG.SHOW_SAMPLE_NAMES and count > 0 then
                  sample = {}
                  local limit = math.min(count, CONFIG.SAMPLE_LIMIT)
                  for i = 1, limit do
                      sample[i] = players[i]
                  end
              end
              sendCountEmbed(count, sample)
          end
          lastCount = count
      end

      local elapsed = os.clock() - start
      local waitFor = intervalSeconds - elapsed
      if waitFor < 0 then waitFor = 0 end
      task.wait(waitFor)
  end
end)
